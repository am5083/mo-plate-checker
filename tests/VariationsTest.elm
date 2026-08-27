module VariationsTest exposing (suite)

import Expect
import Fuzz exposing (string)
import Plate
import Test exposing (Test, describe, fuzz, test)
import Variations


suite : Test
suite =
    describe "Variations"
        [ describe "Repeat Final Character"
            [ test "repeat final character of seed" <|
                \_ ->
                    Expect.equal
                        [ "AHMEDD" ]
                        (Variations.repeatFinal "AHMED")
            , test "repeat final character if seed is empty" <|
                \_ ->
                    Expect.equal
                        []
                        (Variations.repeatFinal "")
            ]
        , describe "Reverse Seed"
            [ test "reverse an empty seed" <|
                \_ ->
                    Expect.equal
                        []
                        (Variations.reverseSeed "")
            , fuzz string "reverse a seed" <|
                \seed ->
                    if String.isEmpty seed then
                        Expect.equal
                            []
                            (Variations.reverseSeed seed)

                    else
                        Expect.equal
                            [ String.reverse seed ]
                            (Variations.reverseSeed seed)
            ]
        , describe "Interior indices"
            [ test "check interior indices, valid string" <|
                \_ ->
                    Expect.equal
                        [ 1, 2 ]
                        (Variations.interiorIndexes "JOHN")
            , test
                "check interior indices, no interior positions"
              <|
                \_ ->
                    Expect.equal
                        []
                        (Variations.interiorIndexes "AE")
            , test "delete character at point 1" <|
                \_ ->
                    Expect.equal
                        "JHN"
                        (Variations.deleteAt 1 "JOHN")
            , test "delete character at point 2" <|
                \_ ->
                    Expect.equal
                        "JON"
                        (Variations.deleteAt 2 "JOHN")
            , test "delete character at point 0" <|
                \_ ->
                    Expect.equal
                        "OHN"
                        (Variations.deleteAt 0 "JOHN")
            , test "delete interior indices john" <|
                \_ ->
                    Expect.equal
                        [ "JHN", "JON" ]
                        (Variations.deleteInterior "JOHN")
            , test "delete interior indices ahmed" <|
                \_ ->
                    Expect.equal
                        [ "AMED", "AHED", "AHMD" ]
                        -- my current plate (AHMD)
                        (Variations.deleteInterior "AHMED")
            , test "delete interior indices ae" <|
                \_ ->
                    Expect.equal
                        []
                        (Variations.deleteInterior "AE")
            , test "replace interior with dash ahmed" <|
                \_ ->
                    Expect.equal
                        [ "A-MED", "AH-ED", "AHM-D" ]
                        (Variations.replaceInteriorWithDash "AHMED")
            , test "replace interior with dash john" <|
                \_ ->
                    Expect.equal
                        [ "J-HN", "JO-N" ]
                        (Variations.replaceInteriorWithDash "JOHN")
            , test "replace interior with dash ae" <|
                \_ ->
                    Expect.equal
                        []
                        (Variations.replaceInteriorWithDash "AE")
            ]
        , describe "Insert interior dashes"
            [ test "inserts a dash at every interior gap in john" <|
                \_ ->
                    Expect.equal
                        [ "J-OHN", "JO-HN", "JOH-N" ]
                        (Variations.insertInteriorDashes "JOHN")
            , test "inserts a dash at every interior gap in ahmed" <|
                \_ ->
                    Expect.equal
                        [ "A-HMED", "AH-MED", "AHM-ED", "AHME-D" ]
                        (Variations.insertInteriorDashes "AHMED")
            , test "inserts a dash into a two-character seed" <|
                \_ ->
                    Expect.equal
                        [ "A-E" ]
                        (Variations.insertInteriorDashes "AE")
            , test "returns no candidates for a one-character seed" <|
                \_ ->
                    Expect.equal
                        []
                        (Variations.insertInteriorDashes "A")
            , test "returns no candidates for an empty seed" <|
                \_ ->
                    Expect.equal
                        []
                        (Variations.insertInteriorDashes "")
            ]
        , describe "Raw candidates"
            [ test "composes transformations in a stable order" <|
                \_ ->
                    Expect.equal
                        [ "AEE", "EA", "A-E", "A E", "A'E" ]
                        (Variations.rawCandidates "AE")
            , test "returns no candidates for an empty seed" <|
                \_ ->
                    Expect.equal
                        []
                        (Variations.rawCandidates "")
            ]
        , describe "Generate"
            [ test "returns the validation error for an invalid seed" <|
                \_ ->
                    case Variations.generate Plate.Regular "@@" of
                        Err error ->
                            Expect.equal Plate.InvalidCharacter error

                        Ok _ ->
                            Expect.fail "Expected the invalid seed to be rejected"
            , test "normalizes the seed and preserves candidate order" <|
                \_ ->
                    case Variations.generate Plate.Regular " ae " of
                        Ok plates ->
                            Expect.equal
                                [ "AEE", "EA", "A-E", "A E", "A'E" ]
                                (List.map Plate.toString plates)

                        Err _ ->
                            Expect.fail "Expected the normalized seed to be accepted"
            , test "filters candidates that are invalid for the category" <|
                \_ ->
                    case Variations.generate Plate.MotorcycleWithTwoSymbols "ABC" of
                        Ok plates ->
                            Expect.equal
                                [ "CBA", "AC", "A-C", "A C", "A'C" ]
                                (List.map Plate.toString plates)

                        Err _ ->
                            Expect.fail "Expected the seed to be accepted"
            , test "does not return an unchanged palindrome" <|
                \_ ->
                    case Variations.generate Plate.Regular "ABA" of
                        Ok plates ->
                            plates
                                |> List.map Plate.toString
                                |> List.member "ABA"
                                |> Expect.equal False

                        Err _ ->
                            Expect.fail "Expected the seed to be accepted"
            , test "keeps one candidate when transformations produce duplicates" <|
                \_ ->
                    case Variations.generate Plate.Regular "AAAA" of
                        Ok plates ->
                            plates
                                |> List.map Plate.toString
                                |> List.filter (\candidate -> candidate == "AAA")
                                |> List.length
                                |> Expect.equal 1

                        Err _ ->
                            Expect.fail "Expected the seed to be accepted"
            ]
        , describe "Stable unique"
            [ test "keeps only the first occurrence in the original order" <|
                \_ ->
                    Expect.equal
                        [ "A", "B", "C" ]
                        (Variations.stableUnique [ "A", "B", "A", "C", "B" ])
            , test "returns an empty list for an empty list" <|
                \_ ->
                    Expect.equal
                        []
                        (Variations.stableUnique [])
            ]
        ]
