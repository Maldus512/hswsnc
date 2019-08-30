module View.Utils exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


boldSpan string =
    span [ style "font-weight" "bold" ] [ text string ]


italicSpan string =
    span [ style "font-style" "italic" ] [ text string ]


mutedlink ( string, link ) =
    Html.li []
        [ case link of
            Nothing ->
                div [ class "text-muted" ] [ text string ]

            Just url ->
                Html.a [ class "text-muted", href url, Html.Attributes.target "_blank" ] [ text string ]
        ]

mainPageBg content =
    div [class "secondarybg"] [
        div [class "bg"] [
            content
        ]
    ]