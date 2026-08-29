module MainTest exposing (suite)

import Availability
import AvailabilityApi
import Expect
import Html.Attributes as Attributes
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


initialModel : Main.Model
initialModel =
    Main.init ()
        |> Tuple.first


modelAfter : String -> Main.Model
modelAfter str =
    Main.update (Main.SeedChange str) initialModel
        |> Tuple.first


suite : Test
suite =
    describe "Main"
        [ describe "correctly render normalized seed '  ahmed  '"
            [ test "renders normalized seed + value" <|
                \_ ->
                    Main.view (modelAfter "  ahmed  ")
                        |> Query.fromHtml
                        |> Query.has [ Selector.text "Normalized seed: AHMED" ]
            , test "update preserves raw input for domain normalization" <|
                \_ ->
                    modelAfter " ABCDEFG "
                        |> .seed
                        |> Expect.equal " ABCDEFG "
            , test "render at least \"AHMEDD\"" <|
                \_ ->
                    Main.view (modelAfter "AHMED")
                        |> Query.fromHtml
                        |> Query.has [ Selector.text "AHMEDD" ]
            , test "updating with invalid characters shows invalid-character method" <|
                \_ ->
                    Main.view (modelAfter "AH!!ED")
                        |> Query.fromHtml
                        |> Query.has [ Selector.text "invalid character" ]
            , test "update with empty seed returns empty-plate message" <|
                \_ ->
                    Main.view (modelAfter "")
                        |> Query.fromHtml
                        |> Query.has [ Selector.text "plate is empty" ]
            , test "calling viewVariations (Ok []) renders the no-candidates message" <|
                \_ ->
                    Main.viewVariations (Ok [])
                        |> Query.fromHtml
                        |> Query.has [ Selector.text "no candidates exist" ]
            , test "seed input does not cap the raw value at seven characters" <|
                \_ ->
                    Main.view initialModel
                        |> Query.fromHtml
                        |> Query.find [ Selector.id "seed-input" ]
                        |> Query.hasNot [ Selector.attribute (Attributes.maxlength 7) ]
            , test "stores a successful availability response" <|
                \_ ->
                    Main.update
                        (Main.GotAvailability
                            (Ok
                                { plate = "AHMED"
                                , availability = Availability.Available
                                }
                            )
                        )
                        initialModel
                        |> Tuple.first
                        |> .lifecycle
                        |> Expect.equal
                            (Main.Success Availability.Available)
            , test
                "stores a rate-limit failure with useful feedback"
              <|
                \_ ->
                    Main.update
                        (Main.GotAvailability
                            (Err
                                (AvailabilityApi.ApiFailure AvailabilityApi.RateLimited)
                            )
                        )
                        initialModel
                        |> Tuple.first
                        |> .lifecycle
                        |> Expect.equal
                            (Main.Fail "Too many requests; try again later")
            , test "stores an invalid plate failure with useful feedback" <|
                \_ ->
                    Main.update
                        (Main.GotAvailability
                            (Err
                                (AvailabilityApi.ApiFailure AvailabilityApi.InvalidPlate)
                            )
                        )
                        initialModel
                        |> Tuple.first
                        |> .lifecycle
                        |> Expect.equal
                            (Main.Fail "Plate not valid")
            , test "repeated button press while already loading" <|
                \_ ->
                    Main.update Main.CheckAvailability
                        { initialModel | lifecycle = Main.Loading }
                        |> Tuple.first
                        |> .lifecycle
                        |> Expect.equal Main.Loading
            , test "changes lifecycle to Loading after button press" <|
                \_ ->
                    Main.update Main.CheckAvailability initialModel
                        |> Tuple.first
                        |> .lifecycle
                        |> Expect.equal Main.Loading
            ]
        ]
