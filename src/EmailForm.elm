module EmailForm exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Validate exposing (..)
import Json.Encode as Enc
import Http


validator =
    Validate.all
        [ ifBlank .email ( Email, "inserire una email" )
        , ifBlank .name ( Name, "inserire un nome" )
        , ifBlank .emailBody ( Content, "inserire il contenuto")
        ]


viewFormErrors : FormField -> List Error -> Html msg
viewFormErrors field errors =
    errors
        |> List.filter (\( fieldError, _ ) -> fieldError == field)
        |> List.map (\( _, error ) -> li [] [ text error ])
        |> ul [ class "form-errors" ]

isFormError : FormField -> List Error -> Bool
isFormError field errors =
    errors |> List.any (\(fieldError, _) -> fieldError == field)

emailPostRequest model msg =
    Http.post {
        url = "/cgi-bin/emailrequest.py"
        , body = Http.jsonBody <| Enc.object [("name", Enc.string model.name), ("email", Enc.string model.email), ("content", Enc.string model.emailBody)]
        , expect = Http.expectString msg
    }

requestState model =
    case model.emailRequestResult of
        Nothing -> input [ class "submit-email", type_ "submit", value "Invia" ] []
        Just Success -> div [class "submit-email submit-success"] [text "Messaggio inviato!"]
        Just Progress -> div [class "submit-email submit-progress lds-dual-ring"] []
        Just Failure -> div [class "submit-email submit-failure"] [text "Errore!"]
