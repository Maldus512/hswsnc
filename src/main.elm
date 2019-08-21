module Main exposing (main)

import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Carousel as Carousel
import Bootstrap.Carousel.Slide as Slide
import Bootstrap.General.HAlign as HAlign
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col
import Bootstrap.Navbar as Navbar
import Browser
import Browser.Dom as Dom
import Browser.Navigation as Navigation
import Css exposing (..)
import Debug
import EmailForm exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Styled.Attributes exposing (css)
import Http
import Model exposing (..)
import Task exposing (Task)
import Tuple exposing (first)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser, s, top)
import Validate exposing (validate)


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


init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( navState, navCmd ) =
            Navbar.initialState NavMsg

        ( model, urlCmd ) =
            urlUpdate url { navKey = key, navState = navState, page = Home, carouselState = Carousel.initialState, email = "", emailBody = "", name = "", errors = [], emailRequestResult = Nothing }
    in
    ( model, Cmd.batch [ urlCmd, navCmd ] )



-- Update


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)


urlUpdate : Url -> Model -> ( Model, Cmd Msg )
urlUpdate url model =
    case decode url of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just route ->
            let
                x =
                    Debug.log "route" route
            in
            ( { model | page = route }, resetViewport )


decode : Url -> Maybe Page
decode url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> UrlParser.parse routeParser


routeParser : Parser (Page -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home top
        , UrlParser.map Prodotti (s "prodotti")
        , UrlParser.map Contatti (s "contatti")
        , UrlParser.map Presentazioni (s "chisiamo")
        ]


type Msg
    = NoOp
    | NavMsg Navbar.State
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | CarouselMsg Carousel.Msg
    | ContactUs
    | SubmitEmail
    | SetEmail String
    | SetName String
    | SetContent String
    | EmailResult (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        NoOp ->
            ( model, Cmd.none )

        NavMsg state ->
            ( { model | navState = state }, Cmd.none )

        SubmitEmail ->
            case validate validator model of
                Ok _ ->
                    ( { model | errors = [], emailRequestResult = Just Progress }, emailPostRequest model EmailResult )

                -- Run HTTP request
                Err errors ->
                    ( { model | errors = errors }, Cmd.none )

        EmailResult (Ok _) ->
            ( { model | emailRequestResult = Just Success }, Cmd.none )

        EmailResult (Err _) ->
            ( { model | emailRequestResult = Just Failure }, Cmd.none )

        SetName name ->
            ( { model | name = name }, Cmd.none )

        SetEmail email ->
            ( { model | email = email }, Cmd.none )

        SetContent content ->
            ( { model | emailBody = content }, Cmd.none )

        LinkClicked req ->
            case req of
                Browser.Internal url ->
                    ( { model | errors = [], emailRequestResult = Nothing }, Navigation.pushUrl model.navKey <| Url.toString url )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            urlUpdate url model

        ContactUs ->
            let
                url =
                    Url.fromString "http://www.hswsnc.com/#contatti"
            in
            case url of
                Just succ ->
                    urlUpdate succ model

                Nothing ->
                    ( model, Cmd.none )

        CarouselMsg subMsg ->
            ( { model | carouselState = Carousel.update subMsg model.carouselState }, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Navbar.subscriptions model.navState NavMsg
        , Carousel.subscriptions model.carouselState CarouselMsg
        ]



-- View


boldSpan string =
    span [style "font-weight" "bold"] [text string]

italicSpan string =
    span [style "font-style" "italic"] [text string]


isSelected model page =
    if model.page == page then
        class "selected-nav-item"

    else
        class ""


menu : Model -> Html Msg
menu model =
    Navbar.config NavMsg
        |> Navbar.attrs [ id "navbar", class "shadow" ]
        |> Navbar.withAnimation
        |> Navbar.collapseMedium
        |> Navbar.fixTop
        |> Navbar.primary
        -- |> Navbar.container
        |> Navbar.brand [ id "brand", href "#", class "text-light" ] [ img [ id "logo", class "logo", src "res/images/hsw.png" ] [] ]
        |> Navbar.items
            [ Navbar.itemLink [ href "#prodotti", isSelected model Prodotti ] [ text "Prodotti" ]
            , Navbar.itemLink [ href "#chisiamo", isSelected model Presentazioni ] [ text "Chi Siamo" ]
            , Navbar.itemLink [ href "#contatti", isSelected model Contatti ] [ text "Contattaci" ]
            ]
        --|> Navbar.attrs [class "d-flex flex-row-reverse"]
        |> Navbar.view model.navState


locationCard =
    Card.config [ Card.outlineInfo, Card.attrs [ class "maincard" ] ]
        |> Card.block []
            [ Block.custom
                (Html.iframe
                    [ src "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2846.0404054473865!2d11.233438915525248!3d44.49383887910152!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x477fd6e56b98afcb%3A0xc3c03558fe15590f!2sVia+Roma%2C+57%2C+40069+Zona+Industriale+BO!5e0!3m2!1sit!2sit!4v1566202372581!5m2!1sit!2sit"
                    , id "locationmap"
                    ]
                    []
                )
            , Block.quote [ class "limited" ]
                [ div [ class "maincardtext" ]
                    [ h1 [] [ text "Dove siamo" ]
                    , p [] [ text """La nostra sede produttiva si trova nella zona industriale di Zola Predosa, 
                                    presso il complesso dell'area 57. L'indirizzo completo è Via Roma 57/G, Zola Predosa (BO)""" ]
                    ]
                ]
            ]
        |> Card.view


mainCard =
    Card.config [ Card.outlineInfo, Card.attrs [ class "topcard" ] ]
        |> Card.block []
            [ Block.custom
                (div []
                    [ div [ class "headersm" ]
                        [ img [ class "maincontentimage left", src "res/images/software.png" ] []
                        , div [ class "maincontentimage" ] []
                        , img [ class "maincontentimage right", src "res/images/hardware.png" ] []
                        ]
                    , img [ class "maincontentimage headermd left", src "res/images/software.png" ] []
                    , img [ class "maincontentimage headermd right", src "res/images/hardware.png" ] []
                    , div [ style "display" "flex", style "height" "100%" ]
                        [ div [ class "maincardtext" ]
                            [ h1 [] [ text "Hardware e Software" ]
                            , div []
                                [ p []
                                    [ text """HSW snc è un'azienda nata a Bologna con lo 
                                    scopo di realizzare soluzioni """
                                    , boldSpan "efficienti"
                                    , text """ in tutti i campi dove queste fossero richieste.
                                    Nel corso degli anni si è specializzata in 
                                    applicazioni per il controllo industriale, sensoristica
                                    avanzata, dispositivi per utilizzo privato.
                                    """
                                    ]
                                , p []
                                    [ text """
                                    Grazie all'"""
                                    ,  boldSpan "esperienza"
                                    , text """ che vanta in molteplici campi
                                    HSW può fornire una """
                                    , boldSpan "consulenza specialistica e approfondita"
                                    , text """ nel superamento dei problemi e 
                                    implementazione delle soluzioni.
                                """
                                    ]
                                ]
                            ]
                        ]
                    ]
                )
            ]
        |> Card.view


secondaryCard =
    Grid.container []
        [ Grid.row []
            [ Grid.col [ Bootstrap.Grid.Col.md8 ]
                [ Card.config [ Card.outlineInfo, Card.attrs [ class "faderight" ] ]
                    |> Card.block []
                        [ Block.titleH1 [] [ text "I nostri prodotti" ]
                        , Block.quote []
                            [ italicSpan "La nostra azienda può vantare una vasta esperienza sotto forma di molteplici dispositivi progettati e sviluppati nel corso degli anni."
                            ]
                        , Block.custom
                            (button [ class "discover" ] [ text "scopri di piu'" ])
                        ]
                    |> Card.view
                ]
            ]
        , Grid.row []
            [ Grid.col [ Bootstrap.Grid.Col.md4 ] []
            , Grid.col [ Bootstrap.Grid.Col.md8 ]
                [ Card.config [ Card.outlineInfo, Card.attrs [ class "fadeleft" ] ]
                    |> Card.block []
                        [ Block.titleH1 [] [ text "Soluzioni ad Hoc e Consulenze" ]
                        , Block.quote []
                            [ text "Il nostro punto di forza è la creazione di "
                            , boldSpan "soluzioni su misura",
                            text " progettate in stretta collaborazione con il cliente. Contattaci per una valutazione di fattibilità sulla realizzazione delle tue idee!"
                            ]
                        , Block.custom
                            (button [ class "discover", onClick ContactUs ] [ text "Richiedi un colloquio" ])
                        ]
                    |> Card.view
                ]
            ]
        , Grid.row []
            [ Grid.col [ Bootstrap.Grid.Col.md8 ]
                [ Card.config [ Card.outlineInfo, Card.attrs [ class "faderight" ] ]
                    |> Card.block [ Block.attrs [ id "elmrustcard" ] ]
                        [ Block.custom (img [ id "elmrust", src "res/images/elmrust.png" ] [])
                        , Block.titleH1 [] [ text "Innovazione e Avanguardia" ]
                        , Block.quote []
                            [ italicSpan "Siamo costantemente spinti alla ricerca di nuove tecnologie e paradigmi da applicare nei nostri prodotti"
                            ]
                        ]
                    |> Card.view
                ]
            ]
        ]


mainContent =
    Grid.container [ class "maincontainer" ]
        [ mainCard
        , secondaryCard
        ]


emailForm model =
    Card.config [ Card.outlineInfo, Card.attrs [ class "maincard formcard" ] ]
        |> Card.block []
            [ Block.custom
                (Html.form [ Html.Events.onSubmit SubmitEmail ]
                    [ --(Html.form [action "/cgi-bin/script.py", method "post", enctype "application/x-www-form-urlencoded"] [
                      p []
                        [ label [ for "name" ] [ text "Nome" ]
                        , input
                            [ type_ "text"
                            , placeholder "Nome"
                            , classFormError Name model.errors
                            , name "name"
                            , Html.Events.onInput SetName
                            ]
                            []
                        ]
                    , p []
                        [ label [ for "mail" ] [ text "Mail" ]
                        , input
                            [ type_ "email"
                            , placeholder "Email a cui risponderemo"
                            , classFormError Name model.errors
                            , name "mail"
                            , Html.Events.onInput SetEmail
                            ]
                            []
                        ]
                    , p []
                        [ textarea
                            [ placeholder "Scrivi il tuo messaggio"
                            , classFormError Content model.errors
                            , name "content"
                            , Html.Events.onInput SetContent
                            ]
                            []
                        ]
                    , requestState model
                    ]
                )
            ]
        |> Card.view


slide pimg title content =
    Slide.config []
        (Slide.customContent
            (div [ class "myslide" ]
                [ div [ class "myslidecontent" ]
                    [ img [ src pimg ] []
                    , div []
                        [ h1 [] [ text title ]
                        , p [] [ text content ]
                        , button [ class "discover" ] [ text "scopri di piu'" ]
                        ]
                    ]
                ]
            )
        )


productContent model =
    Carousel.config CarouselMsg [ class "maincard" ]
        |> Carousel.withIndicators
        |> Carousel.withControls
        |> Carousel.slides
            [ slide "res/images/stiro.png" "Controllo industriale" "HSW si occupa da decenni di assicurare funzionamento e sicurezza in applicazioni industriali di varia natura."
            , slide "res/images/drycontrol.png" "Sensoristica" "Soluzioni affidabili per requisiti specifici nel rilevamento di parametri ambientali."
            , slide "res/images/polmac1.png" "Connettività e Gestione Remota" "Capacità wireless WiFi o Bluetooth integrata in tutti i dispositivi che lo richiedano, senza incrementare i costi."
            , slide "res/images/app.jpg" "Integrazione" "La maggior parte dei nostri dispositivi prevedono mezzi di comunicazione con l'esterno; in fase di progettazione è possibile richiedere l'integrazione con altre tecnologie come smartphone e pc."
            ]
        |> Carousel.view model.carouselState


mutedlink ( string, link ) =
    Html.li []
        [ Html.a [ class "text-muted", href link ] [ text string ]
        ]


pageFooter =
    footer [ class "page-footer border-top border-primary" ]
        [ Grid.row []
            [ Grid.col [ Bootstrap.Grid.Col.md5 ]
                [ img [ src "res/images/hsw.png", Html.Attributes.height 25 ] []
                , Html.small [ class "text-muted d-block" ] [ text "© 2017-2018" ]
                ]
            , Grid.col [ Bootstrap.Grid.Col.md2 ]
                [ h6 [] [ text "Network" ]
                , Html.ul [ class "list-unstyled" ]
                    (List.map mutedlink [ ( "Linkedin", "https://www.linkedin.com/company/hsw/about/" ), ( "Github", "https://github.com/maldus512" ), ( "Medium", "https://medium.com/@mattia512maldini" ) ])
                ]
            , Grid.col [ Bootstrap.Grid.Col.md2 ]
                [ h6 [] [ text "Prodotti" ]
                , Html.ul [ class "list-unstyled" ]
                    (List.map mutedlink [ ( "Lavanderia", "#" ), ( "Lavasecco", "#" ), ( "Stiro", "#" ), ( "Agricoltura", "#" ), ( "Lavorazione Pelli", "#" ) ])
                ]
            , Grid.col [ Bootstrap.Grid.Col.md3 ]
                [ h6 [] [ text "Contatti" ]
                , Html.ul [ class "list-unstyled" ]
                    (List.map mutedlink
                        [ ( "Sede legale : Via del Francia 14, Casalecchio (BO)"
                          , "https://www.google.it/maps/place/Via+del+Francia,+14,+40033+Casalecchio+di+Reno+BO/@44.48637,11.286786,17z/data=!3m1!4b1!4m5!3m4!1s0x477fd4376f796989:0xdceb8472cb2fded3!8m2!3d44.48637!4d11.28898"
                          )
                        , ( "Sede produttiva : Via Roma 57/g, Zola Predosa (BO)", "https://www.google.it/maps/place/Via+Roma,+57,+40069+Zona+Industriale+BO/@44.4938389,11.2334336,17z/data=!3m1!4b1!4m5!3m4!1s0x477fd6e56b98afcb:0xc3c03558fe15590f!8m2!3d44.4938389!4d11.2356276" )
                        , ( "Email : info@hswsnc.com", "mailto:info@hswsnc.com" )
                        , ( "Tel : (+39) 051 619 619 1", "tel:0039-051-619-6191" )
                        , ( "P.IVA : BO 01688021201", "#" )
                        ]
                    )
                ]
            ]
        , Html.a [ id "poweredby", href "https://elm-lang.org/", class "text-muted" ] [ span [] [ text "Powered by Elm", img [ src "res/images/elm.png", style "height" "14px", style "margin-left" "5px" ] [] ] ]
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "HSW"
    , body =
        [ div [ id "top" ] []
        , menu model
        , button [ id "back2top", class "icon-chevron-up" ] []
        , div [ class "bodybg" ]
            [ div [ class "bg" ]
                [ case model.page of
                    Home ->
                        mainContent

                    Contatti ->
                        emailForm model

                    Presentazioni ->
                        locationCard

                    Prodotti ->
                        productContent model

                    NotFound ->
                        Grid.container [] []
                ]
            ]
        , pageFooter
        ]
    }
