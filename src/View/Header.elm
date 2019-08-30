module View.Header exposing (menubar)

import Bootstrap.Navbar as Navbar
import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


isSelected model page =
    if model.page == page then
        class "selected-nav-item"

    else
        class ""


menubar : Model -> Html Msg
menubar model =
    Navbar.config NavMsg
        |> Navbar.attrs [ id "navbar", class "shadow" ]
        |> Navbar.withAnimation
        |> Navbar.collapseMedium
        |> Navbar.fixTop
        |> Navbar.primary
        -- |> Navbar.container
        |> Navbar.brand [ id "brand", href "#", class "text-light" ] [ img [ id "logo", class "logo", src "res/images/hsw.png" ] [] ]
        |> Navbar.items
            [ Navbar.itemLink [ href "#prodotti", isSelected model Prodotti ] [ text "Prodotti" ]
            , Navbar.itemLink [ href "#chisiamo", isSelected model Presentazioni ] [ text "Chi Siamo" ]
            , Navbar.itemLink [ href "#contatti", isSelected model Contatti ] [ text "Contattaci" ]
            ]
        --|> Navbar.attrs [class "d-flex flex-row-reverse"]
        |> Navbar.view model.navState
