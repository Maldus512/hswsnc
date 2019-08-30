module EmailData exposing (ValidatedEmailData, clearFormError, emailFormValidator, emailPostRequest, initEmailData, isFormError, requestState, validateForm, viewFormErrors)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Encode as Enc
import Maybe exposing (withDefault)
import Model exposing (..)
import Validate exposing (..)


type alias ValidatedEmailData =
    { name : String
    , email : String
    , content : String
    }


initEmailData =
    EmailRequestData False "" "" ""


emailFormValidator : Validator ( FormField, String ) Model
emailFormValidator =
    Validate.all
        [ ifBlank .email ( Email, "inserire una email" )
        , ifBlank .name ( Name, "inserire un nome" )
        , ifBlank .emailBody ( Content, "inserire il contenuto" )
        , ifFalse .consent ( Consent, "Accettare" )
        ]


validateForm data =
    validate emailFormValidator data


viewFormErrors : FormField -> List FormError -> Html msg
viewFormErrors field errors =
    errors
        |> List.filter (\( fieldError, _ ) -> fieldError == field)
        |> List.map (\( _, error ) -> li [] [ text error ])
        |> ul [ class "form-errors" ]


isFormError : FormField -> List FormError -> Bool
isFormError field errors =
    errors |> List.any (\( fieldError, _ ) -> fieldError == field)


clearFormError field errors =
    errors |> List.filter (\( fieldError, _ ) -> fieldError /= field)


emailPostRequest model msg =
    let
        data =
            Validate.fromValid model
    in
    Http.post
        { url = "/cgi-bin/emailrequest.py"
        , body = Http.jsonBody <| Enc.object [ ( "name", Enc.string data.name ), ( "email", Enc.string data.email ), ( "content", Enc.string data.emailBody ) ]
        , expect = Http.expectString msg
        }


requestState model =
    case model.emailRequestResult of
        Nothing ->
            input [ class "submit-email", type_ "submit", value "Invia" ] []

        Just Success ->
            div [ class "submit-email submit-success" ] [ text "Messaggio inviato!" ]

        Just Progress ->
            div [ class "submit-email submit-progress lds-dual-ring" ] []

        Just Failure ->
            div [ class "submit-email submit-failure" ] [ text "Errore!" ]
