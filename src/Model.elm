module Model exposing (EmailRequestData, FormError, FormField(..), Model, Page(..), RequestResult(..))

import Bootstrap.Carousel as Carousel
import Bootstrap.Navbar as Navbar
import Browser.Navigation as Navigation
import Http



-- Model


type FormField
    = Email
    | Content
    | Name
    | Consent


type alias EmailRequestData =
    { consent : Bool
    , name : String
    , email : String
    , emailBody : String
    }


type alias FormError =
    ( FormField, String )


type RequestResult
    = Success
    | Failure
    | Progress


type Page
    = Home
    | Prodotti
    | Contatti
    | Presentazioni
    | NotFound

type alias Model =
    { navState : Navbar.State
    , navKey : Navigation.Key
    , page : Page
    , consent : Bool
    , email : String
    , name : String
    , emailBody : String
    , emailRequestResult : Maybe RequestResult
    , errors : List FormError
    , carouselState : Carousel.State
    }
