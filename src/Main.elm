port module Main exposing (main)

import Bootstrap.Accordion as Accordion
--import Bootstrap.CDN as CDN
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Carousel as Carousel
import Bootstrap.General.HAlign as HAlign
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col
import Bootstrap.Navbar as Navbar
import Browser
import Browser.Dom as Dom
import Browser.Navigation as Navigation
import Css exposing (..)
import EmailData exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Styled.Attributes exposing (css)
import Http
import Model exposing (..)
import Task exposing (Task)
import Tuple exposing (first)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser)
import Validate exposing (validate)
import View.About exposing (..)
import View.EmailForm exposing (..)
import View.Footer exposing (..)
import View.Header exposing (..)
import View.HomePage exposing (..)
import View.ProductCarousel exposing (..)
import View.ProductFilter exposing (..)
import View.Utils exposing (..)


type alias Flags =
    {}


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type CarouselMsg
    = Roba (List Page)


port scrollTop : Int -> Cmd msg


init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( navState, navCmd ) =
            Navbar.initialState NavMsg

        ( model, urlCmd ) =
            urlUpdate url
                { navKey = key
                , navState = navState
                , accordionState = Accordion.initialStateCardOpen "filter"
                , page = Home
                , carouselState = Carousel.initialState
                , email = ""
                , emailBody = ""
                , name = ""
                , consent = False
                , errors = []
                , emailRequestResult = Nothing
                , products = ProductData [] [] []
                }
    in
    ( model, Cmd.batch [ urlCmd, navCmd, productListGetRequest ProductsResult ] )



-- Update


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)


routeTo string model =
    let
        url =
            Url.fromString string
    in
    case url of
        Just succ ->
            urlUpdate succ model

        Nothing ->
            ( model, Cmd.none )


urlUpdate : Url -> Model -> ( Model, Cmd Msg )
urlUpdate url model =
    case decode url of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just route ->
            let
                ( navState, navCmd ) =
                    Navbar.initialState NavMsg
            in
            ( { model | page = route, navState = navState }, Cmd.batch [ resetViewport, navCmd ] )


decode : Url -> Maybe Page
decode url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> UrlParser.parse routeParser


routeParser : Parser (Page -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map Prodotti (UrlParser.s "prodotti")
        , UrlParser.map FiltroProdotti (UrlParser.s "filtroprodotti")
        , UrlParser.map Contatti (UrlParser.s "contatti")
        , UrlParser.map Presentazioni (UrlParser.s "chisiamo")
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ScrollTop ->
            ( model, scrollTop 500 )

        NavMsg state ->
            ( { model | navState = state }, Cmd.none )

        AccordionMsg state ->
            ( { model | accordionState = state }, Cmd.none )

        SubmitEmail ->
            case validate emailFormValidator model of
                Ok validated ->
                    ( { model | errors = [], emailRequestResult = Just Progress }, emailPostRequest validated EmailResult )

                -- Run HTTP request
                Err errors ->
                    ( { model | errors = errors }, Cmd.none )

        ProductsResult (Ok products) ->
            ( updateProducts model products, Cmd.none )

        ProductsResult (Err _) ->
            ( model, Cmd.none )

        EmailResult (Ok _) ->
            ( { model | emailRequestResult = Just Success }, Cmd.none )

        EmailResult (Err _) ->
            ( { model | emailRequestResult = Just Failure }, Cmd.none )

        SetFormField field string ->
            case field of
                Name ->
                    ( { model | name = string }, Cmd.none )

                Email ->
                    ( { model | email = string }, Cmd.none )

                Content ->
                    ( { model | emailBody = string }, Cmd.none )

                Consent ->
                    ( model, Cmd.none )

        ToggleConsent ->
            ( { model | consent = not model.consent, errors = clearFormError Consent model.errors }, Cmd.none )

        ToggleProductTag tag ->
            ( toggleProductTag model tag, Cmd.none )

        LinkClicked req ->
            case req of
                Browser.Internal url ->
                    ( { model | errors = [], emailRequestResult = Nothing }, Navigation.pushUrl model.navKey <| Url.toString url )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            urlUpdate url model

        CarouselMsg subMsg ->
            ( { model | carouselState = Carousel.update subMsg model.carouselState }, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Navbar.subscriptions model.navState NavMsg
        , Carousel.subscriptions model.carouselState CarouselMsg
        , Accordion.subscriptions model.accordionState AccordionMsg
        ]



-- View


view : Model -> Browser.Document Msg
view model =
    { title = "HSW - Hardware & Software Design and Development"
    , body =
        [ div [ id "top" ] []
        --CDN.stylesheet ,
        , menubar model
        , button [ id "back2top", class "icon-chevron-up", onClick ScrollTop ] []
        , case model.page of
            Home ->
                mainContent |> mainPageBg

            Contatti ->
                emailForm model |> mainPageBg

            Presentazioni ->
                locationCard |> mainPageBg

            Prodotti ->
                productContent model |> mainPageBg

            FiltroProdotti ->
                productFilter model |> mainPageBg

            NotFound ->
                Card.config [ Card.warning ] |> Card.block [] [ Block.titleH4 [] [ text "404" ], Block.text [] [ text "Pagina non trovata" ] ] |> Card.view |> mainPageBg
        , pageFooter
        ]
    }
