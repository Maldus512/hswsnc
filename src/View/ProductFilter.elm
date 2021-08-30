module View.ProductFilter exposing (addProductTag, isContained, productCard, productCheckboxes, productDecoder, productFilter, productListGetRequest, productsDecoder, removeProductTag, selectedProducts, toggleProductTag, updateProducts)

import Bootstrap.Accordion as Accordion
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Carousel as Carousel
import Bootstrap.Carousel.Slide as Slide
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JD
import List.Extra as LE
import Model exposing (..)


addProductTag : Model -> String -> Model
addProductTag model tag =
    let
        tags =
            model.products.selectedProductTags ++ [ tag ]

        products =
            model.products

        newProducts =
            { products | selectedProductTags = tags }
    in
    { model | products = newProducts }


removeProductTag : Model -> String -> Model
removeProductTag model tag =
    let
        tags =
            List.filter (\x -> x /= tag) model.products.selectedProductTags

        products =
            model.products

        newProducts =
            { products | selectedProductTags = tags }
    in
    { model | products = newProducts }


toggleProductTag model tag =
    if List.member tag model.products.selectedProductTags then
        removeProductTag model tag

    else
        addProductTag model tag


updateProducts model plist =
    let
        productData =
            model.products

        foundTags =
            List.concatMap (\p -> p.tags) plist |> LE.unique

        newProductData =
            { productData | productList = plist, productTags = foundTags }
    in
    { model | products = newProductData }


productCheckboxes : List String -> List (Html Msg)
productCheckboxes tags =
    List.map (\s -> span [ class "accordioncheckbox" ] [ label [ for ("tag" ++ s) ] [ text s ], input [ type_ "checkbox", id ("tag" ++ s), onClick (ToggleProductTag s) ] [] ]) tags


isContained : List a -> List a -> Bool
isContained l1 l2 =
    List.foldr (&&)
        True
        (List.map (\el -> List.member el l2) l1)


selectedProducts : ProductData -> List ProductInfo
selectedProducts data =
    let
        selected =
            data.selectedProductTags

        products =
            data.productList
    in
    List.filter (\p -> isContained selected p.tags) products


productListGetRequest msg =
    Http.get
        { url = "/data/prodotti.json"
        , expect = Http.expectJson msg productsDecoder
        }


productsDecoder : JD.Decoder (List ProductInfo)
productsDecoder =
    JD.list productDecoder


productDecoder : JD.Decoder ProductInfo
productDecoder =
    JD.map5 ProductInfo
        (JD.field "name" JD.string)
        (JD.field "description" (JD.list JD.string))
        (JD.maybe (JD.field "image" JD.string))
        (JD.field "tags" (JD.list JD.string))
        (JD.maybe (JD.field "datasheet" JD.string))


tagList tags =
    List.map (\t -> span [ class "tag" ] [ text t ]) tags


productCard : ProductInfo -> Html Msg
productCard product =
    let
        immagine =
            case product.image of
                Just imgfile ->
                    img [ class "left producticon", src <| "res/images/" ++ imgfile ] []

                Nothing ->
                    div [] []
    in
    Card.config [ Card.outlineInfo, Card.attrs [ class "productcard" ] ]
        |> Card.footer [] (tagList product.tags)
        |> Card.block []
            [ Block.titleH4 [] [ text product.name ]
            , Block.custom <|
                div [ class "productinfo" ]
                    [ immagine
                    , div [] <|
                        List.map
                            (\d -> p [] [ text d ])
                            product.description
                    , Maybe.map (\datasheet -> a [ href ("res/pdf/" ++ datasheet), class "discover", target "_blank" ] [ text "scheda tecnica" ]) product.datasheet
                        |> Maybe.withDefault (div [] [])
                    ]
            ]
        |> Card.view


productFilter : Model -> Html Msg
productFilter model =
    div [ id "productfilter" ]
        ([ Card.config [ Card.outlineInfo, Card.attrs [ id "infocatalogo" ] ]
            |> Card.block []
                [ Block.titleH1 [] [ text "Catalogo" ]
                , Block.custom <|
                    div [ class "didascalia" ]
                        [ text "Questo catalogo ha la finalità di delineare il nostro campo di lavoro e indicare le nostre competenze. Soltanto parte dei dispositivi sono pronti per l'utilizzo diretto da parte di un cliente; se pensate che una soluzione possa fare al caso vostro nella forma in cui è descritta o con modifiche, non esitate a ", a [ href "#contatti" ] [ text "contattatarci" ] ]
                ]
            |> Card.view
         , Accordion.config AccordionMsg
            |> Accordion.withAnimation
            |> Accordion.cards
                [ Accordion.card
                    { id = "filter"
                    , options = []
                    , header =
                        Accordion.header [ id "filterheader" ] <| Accordion.toggle [] [ text "Filtro prodotti" ]
                    , blocks =
                        [ Accordion.block []
                            [ Block.custom <|
                                div [] <|
                                    productCheckboxes
                                        model.products.productTags
                            ]
                        ]
                    }
                ]
            |> Accordion.view model.accordionState
         ]
            ++ List.map productCard (selectedProducts model.products)
        )
