module PlateTest exposing (suite)

import Debug
import Expect
import Plate
import Test exposing (Test, describe, test)


expectValid category rawInput expected =
    case Plate.validate category rawInput of
        Ok plate ->
            Expect.equal expected (Plate.toString plate)

        Err error ->
            Expect.fail
                ("Expected a valid plate, but received "
                    ++ Debug.toString error
                )


expectError expected category rawInput =
    Expect.equal
        (Err expected)
        (Plate.validate category rawInput)



-- TODO: Revise tests in Elm
-- NOTE: I did not write this test. The syntax makes sense conceptually, but I
-- am not really worried about tests right now.


categoryBoundaryTests : List Test
categoryBoundaryTests =
    [ { label = "Regular"
      , category = Plate.Regular
      , atLimit = "ABCDEFG"
      , overLimit = "ABCDEFGH"
      }
    , { label = "RegularWithSymbol"
      , category = Plate.RegularWithSymbol
      , atLimit = "ABCDEF"
      , overLimit = "ABCDEFG"
      }
    , { label = "RegularWithTwoSymbols"
      , category = Plate.RegularWithTwoSymbols
      , atLimit = "ABCD"
      , overLimit = "ABCDE"
      }
    , { label = "Motorcycle"
      , category = Plate.Motorcycle
      , atLimit = "ABCDEF"
      , overLimit = "ABCDEFG"
      }
    , { label = "MotorcycleWithSymbol"
      , category = Plate.MotorcycleWithSymbol
      , atLimit = "ABCDE"
      , overLimit = "ABCDEF"
      }
    , { label = "MotorcycleWithTwoSymbols"
      , category = Plate.MotorcycleWithTwoSymbols
      , atLimit = "ABC"
      , overLimit = "ABCD"
      }
    ]
        |> List.concatMap
            (\boundary ->
                [ test (boundary.label ++ " accepts its maximum length") <|
                    \_ ->
                        expectValid
                            boundary.category
                            boundary.atLimit
                            boundary.atLimit
                , test (boundary.label ++ " rejects one character over its maximum") <|
                    \_ ->
                        expectError
                            Plate.InvalidLength
                            boundary.category
                            boundary.overLimit
                ]
            )


suite : Test
suite =
    describe "Plate"
        [ describe "normalize"
            [ test "trims surrounding whitespace" <|
                \_ ->
                    Expect.equal
                        "BLABLA"
                        (Plate.normalize "   BLABLA   ")
            , test "converts lowercase letters to uppercase" <|
                \_ ->
                    Expect.equal
                        "ONE HUNDRED PERCENT LOWERCASE"
                        (Plate.normalize "one hundred percent lowercase")
            , test "preserves internal spaces" <|
                \_ ->
                    Expect.equal
                        "MO 123"
                        (Plate.normalize "mo 123")
            ]
        , describe "validate"
            ([ test "normalizes before returning a validated plate" <|
                \_ ->
                    expectValid Plate.Regular " az09 " "AZ09"
             , test "rejects empty input" <|
                \_ ->
                    expectError Plate.EmptyPlate Plate.Regular ""
             , test "rejects input that normalizes to empty" <|
                \_ ->
                    expectError Plate.EmptyPlate Plate.Regular "   "
             , test "rejects an invalid character" <|
                \_ ->
                    expectError Plate.InvalidCharacter Plate.Regular "ABC@123"
             , test "accepts no separator" <|
                \_ ->
                    expectValid Plate.Regular "ABC123" "ABC123"
             , test "accepts one space" <|
                \_ ->
                    expectValid Plate.Regular "ABC 123" "ABC 123"
             , test "accepts one dash" <|
                \_ ->
                    expectValid Plate.Regular "ABC-123" "ABC-123"
             , test "accepts one apostrophe" <|
                \_ ->
                    expectValid Plate.Regular "ABC'123" "ABC'123"
             , test "rejects multiple separators" <|
                \_ ->
                    expectError Plate.TooManySeparators Plate.Regular "A-B C"
             , test "accepts boundary letters and digits" <|
                \_ ->
                    expectValid Plate.Regular "AZ09" "AZ09"
             , test "reports invalid characters before excessive length" <|
                \_ ->
                    expectError Plate.InvalidCharacter Plate.Regular "@@@@@@@@"
             , test "reports excess separators before excessive length" <|
                \_ ->
                    expectError Plate.TooManySeparators Plate.Regular "A--BCDEFG"
             ]
                ++ categoryBoundaryTests
            )
        ]
