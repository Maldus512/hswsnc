module View.EmailForm exposing (emailForm)

import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Carousel as Carousel
import EmailData exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)


classFormError field errors =
    if isFormError field errors then
        class "errorinput"

    else
        class ""


emailForm model =
    Card.config [ Card.outlineInfo, Card.attrs [ class "maincard formcard" ] ]
        |> Card.block []
            [ Block.custom
                (Html.form [ Html.Events.onSubmit SubmitEmail ]
                    [ p []
                        [ label [ for "name" ] [ text "Nome" ]
                        , input
                            [ type_ "text"
                            , placeholder "Nome"
                            , classFormError Name model.errors
                            , name "name"
                            , Html.Events.onInput <| SetFormField Name
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
                            , Html.Events.onInput <| SetFormField Email
                            ]
                            []
                        ]
                    , p []
                        [ textarea
                            [ placeholder "Scrivi il tuo messaggio"
                            , classFormError Content model.errors
                            , name "content"
                            , Html.Events.onInput <| SetFormField Content
                            ]
                            []
                        ]
                    , div []
                        [ input [ type_ "checkbox", name "consent", onClick ToggleConsent, id "consentcb" ] []
                        , label [ classFormError Consent model.errors, class "text-muted gdpr", for "consentcb" ] [ text "Accetto di essere contattato via email" ]
                        ]
                    , requestState model
                    ]
                )
            ]
        |> Card.view
