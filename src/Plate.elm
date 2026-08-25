module Plate exposing (Plate, PlateCategory(..), normalize)

import Html.Attributes exposing (placeholder)
import String exposing (..)



-- PLATE


type Plate
    = Plate String


type PlateCategory
    = Regular String
    | RegularWithSymbol String
    | RegularWithTwoSymbols String
    | Motorcycle String
    | MotorcycleWithSymbol String
    | MotorcycleWithTwoSymbols String


normalize : String -> String
normalize str =
    String.trim (String.toUpper str)


isLegalLength : Plate -> PlateCategory -> Bool
isLegalLength p category =
    let
        len =
            case p of
                Plate str ->
                    String.length str
    in
    if len > 7 then
        False

    else
        case category of
            Regular _ ->
                False

            RegularWithSymbol _ ->
                False

            RegularWithTwoSymbols _ ->
                False

            Motorcycle _ ->
                False

            MotorcycleWithSymbol _ ->
                False

            MotorcycleWithTwoSymbols _ ->
                False


isNotEmpty : Plate -> Bool
isNotEmpty p =
    not
        (String.isEmpty
            (case p of
                Plate str ->
                    str
            )
        )


hasOneSeparator : Plate -> Bool
hasOneSeparator p =
    False
