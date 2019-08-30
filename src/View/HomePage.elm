module View.HomePage exposing (mainContent)

import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import View.Utils exposing (..)
import Model exposing(Msg(..))


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
                                    , boldSpan "esperienza"
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
                            (button [ class "discover", onClick DiscoverMoreProducts] [ text "scopri di piu'" ])
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
                            , boldSpan "soluzioni su misura"
                            , text " progettate in stretta collaborazione con il cliente. Contattaci per una valutazione di fattibilità sulla realizzazione delle tue idee!"
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