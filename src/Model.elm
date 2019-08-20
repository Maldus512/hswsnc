module Model exposing(..)

import Bootstrap.Navbar as Navbar
import Browser.Navigation as Navigation
import Bootstrap.Carousel as Carousel
import Http

-- Model
type FormField
    = Email
    | Content
    | Name


type alias Error =
    ( FormField, String )

type RequestResult = 
    Success | Failure | Progress

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
    , email : String
    , name : String
    , emailBody : String
    , emailRequestResult : Maybe RequestResult
    , errors : List Error
    , carouselState : Carousel.State
    }
