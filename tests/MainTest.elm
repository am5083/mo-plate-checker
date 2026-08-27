module MainTest exposing (suite)

import Debug
import Expect
import Main
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector



--
-- Since `view` returns an immutable `Html` value, Elm views can be **tested**
-- Which is genius lol
--
-- Msg
-- -> update
-- -> Model
-- -> view
-- -> Html Msg
-- -> Query.fromHtml
-- -> Query.has
--
-- NOTE: [BOOKMARK]
--
--
--


suite : Test
suite =
    describe "Main"
        [ describe "correctly render normalized seed '  ahmed  '"
            [ test "renders normalized seed + value" <|
                \_ ->
                    Main.view _
                        |> Query.fromHtml
                        |> Query.has [ Selector.text "Normalized seed: AHMED" ]


            , test "render at least \"AHMEDD\"" <|
                \_ ->
                    Main.view _
                        |> Query.fromHtml
                        |> Query.has [ Selector.text "AHMEDD" ]


            , test "updating with invalid characters shows invalid-character method" <|
                \_ ->
                    let msg = Main.update (Main.SeedChange "AH!!ED") in
                            Main.view _
                                |> Query.fromHtml
                                |> Query.has [ Selector.text "invalid character" ]


            , test "update with empty seed returns empty-plate message" <|
                    let msg = Main.update (Main.SeedChange "AH!!ED") in
                            Main.view _
                                |> Query.fromHtml
                                |> Query.has [ Selector.text "plate is empty" ]


            , test "calling viewVariations (Ok []) renders the no-candidates message" <|
                \_ ->
                    let msg =
                            Main.viewVariations (Ok [])_
                                |> Query.fromHtml
                                |> Query.has [ Selector.text "no candidates exist" ]
            ]
        ]
