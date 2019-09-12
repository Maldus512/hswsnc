module View.ProductCarousel exposing (productContent)

import Bootstrap.Carousel as Carousel
import Bootstrap.Carousel.Slide as Slide
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


slide pimg title content =
    Slide.config []
        (Slide.customContent
            (div [ class "myslide" ]
                [ div [ class "myslidecontent" ]
                    [ img [ src pimg ] []
                    , div []
                        [ h1 [] [ text title ]
                        , p [] [ text content ]
                        , a [ class "discover", href "#filtroprodotti" ] [ text "scopri di piu'" ]
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
            , slide "res/images/cubetto.png" "Interfacciamento utente" "Controllori e visualizzatori per macchinari industriali; interfacce di gestione di sistemi elaborati o autonomi."
            ]
        |> Carousel.view model.carouselState
