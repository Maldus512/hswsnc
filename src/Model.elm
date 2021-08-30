module Model exposing (EmailRequestData, FormError, FormField(..), Model, Msg(..), Page(..), ProductData, ProductInfo, RequestResult(..))

import Bootstrap.Accordion as Accordion
import Bootstrap.Carousel as Carousel
import Bootstrap.Navbar as Navbar
import Browser
import Browser.Navigation as Navigation
import Http
import Url exposing (Url)



-- Model


type alias ProductInfo =
    { name : String
    , description : List String
    , image : Maybe String
    , tags : List String
    , datasheet : Maybe String
    }


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
    | FiltroProdotti
    | Contatti
    | Presentazioni
    | NotFound


type alias ProductData =
    { productList : List ProductInfo
    , productTags : List String
    , selectedProductTags : List String
    }


type alias Model =
    { navState : Navbar.State
    , carouselState : Carousel.State
    , accordionState : Accordion.State
    , navKey : Navigation.Key
    , page : Page
    , consent : Bool
    , email : String
    , name : String
    , emailBody : String
    , emailRequestResult : Maybe RequestResult
    , errors : List FormError
    , products : ProductData
    }


type Msg
    = NoOp
    | NavMsg Navbar.State
    | AccordionMsg Accordion.State
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | CarouselMsg Carousel.Msg
    | SubmitEmail
    | SetFormField FormField String
    | ToggleConsent
    | EmailResult (Result Http.Error String)
    | ProductsResult (Result Http.Error (List ProductInfo))
    | ScrollTop
    | ToggleProductTag String
