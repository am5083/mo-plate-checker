module PlateTest exposing (suite)

import Expect
import Plate
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Plate.normalize"
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
