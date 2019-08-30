module View.Footer exposing (pageFooter)

import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Html exposing (..)
import Html.Attributes exposing (..)
import View.Utils exposing (mutedlink)


pageFooter =
    footer [ class "page-footer border-top border-primary" ]
        [ Grid.row []
            [ Grid.col [ Col.md5 ]
                [ img [ src "res/images/hsw.png", Html.Attributes.height 25 ] []
                , Html.small [ class "text-muted d-block" ] [ text "© 2017-2018" ]
                ]
            , Grid.col [ Col.md2 ]
                [ h6 [] [ text "Network" ]
                , Html.ul [ class "list-unstyled" ]
                    (List.map mutedlink [ ( "Linkedin", Just "https://www.linkedin.com/company/hsw/about/" ), ( "Github", Just "https://github.com/maldus512/hswsnc" ), ( "Medium", Just "https://medium.com/@mattia512maldini" ) ])
                ]
            , Grid.col [ Col.md2 ]
                [ h6 [] [ text "Prodotti" ]
                , Html.ul [ class "list-unstyled" ]
                    (List.map mutedlink [ ( "Lavanderia", Nothing ), ( "Lavasecco", Nothing ), ( "Stiro", Nothing ), ( "Agricoltura", Nothing ), ( "Lavorazione Pelli", Nothing ) ])
                ]
            , Grid.col [ Col.md3 ]
                [ h6 [] [ text "Contatti" ]
                , Html.ul [ class "list-unstyled" ]
                    (List.map mutedlink
                        [ ( "Sede legale : Via del Francia 14, Casalecchio (BO)"
                          , Just "https://www.google.it/maps/place/Via+del+Francia,+14,+40033+Casalecchio+di+Reno+BO/@44.48637,11.286786,17z/data=!3m1!4b1!4m5!3m4!1s0x477fd4376f796989:0xdceb8472cb2fded3!8m2!3d44.48637!4d11.28898"
                          )
                        , ( "Sede produttiva : Via Roma 57/G, Zola Predosa (BO)", Just "https://www.google.it/maps/place/Via+Roma,+57,+40069+Zona+Industriale+BO/@44.4938389,11.2334336,17z/data=!3m1!4b1!4m5!3m4!1s0x477fd6e56b98afcb:0xc3c03558fe15590f!8m2!3d44.4938389!4d11.2356276" )
                        , ( "Email : info@hswsnc.com", Just "mailto:info@hswsnc.com" )
                        , ( "Tel & Fax: (+39) 051 619 6191", Just "tel:0039-051-619-6191" )
                        , ( "Cellulare: (+39) 338 252 5094", Just "tel:0039-338-252-5094" )
                        , ( "P.IVA : BO 01688021201", Nothing )
                        ]
                    )
                ]
            ]
        , Html.a [ id "poweredby", href "https://elm-lang.org/", class "text-muted" ] [ span [] [ text "Powered by Elm", img [ src "res/images/elm.png", style "height" "14px", style "margin-left" "5px" ] [] ] ]
        ]
