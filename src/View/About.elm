module View.About exposing (locationCard)

import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Html exposing (..)
import Html.Attributes exposing (..)

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
