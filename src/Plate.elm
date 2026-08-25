module Plate exposing (Plate, PlateCategory(..), ValidationError(..), normalize, toString, validate)

import String exposing (..)



-- PLATE


type Plate
    = Plate String



-- PLATE CATEGORY


type PlateCategory
    = Regular
    | RegularWithSymbol
    | RegularWithTwoSymbols
    | Motorcycle
    | MotorcycleWithSymbol
    | MotorcycleWithTwoSymbols



-- VALIDATION ERROR


type ValidationError
    = EmptyPlate
    | InvalidCharacter
    | TooManySeparators
    | InvalidLength


normalize : String -> String
normalize str =
    String.trim (String.toUpper str)


isLegal : String -> Int -> Bool
isLegal p c =
    String.length p <= c


isLegalLength : String -> PlateCategory -> Bool
isLegalLength p category =
    let
        len =
            String.length p
    in
    if len > 7 then
        False

    else
        case category of
            Regular ->
                isLegal p 7

            RegularWithSymbol ->
                isLegal p 6

            RegularWithTwoSymbols ->
                isLegal p 4

            Motorcycle ->
                isLegal p 6

            MotorcycleWithSymbol ->
                isLegal p 5

            MotorcycleWithTwoSymbols ->
                isLegal p 3


isNotEmpty : String -> Bool
isNotEmpty p =
    not
        (String.isEmpty p)


hasAtMostOneSeparator : String -> Bool
hasAtMostOneSeparator configuration =
    let
        separatorCount =
            configuration
                |> String.filter
                    (\char -> List.member char [ ' ', '-', '\'' ])
                |> String.length
    in
    separatorCount <= 1


isAlphaNum : Char -> Bool
isAlphaNum char =
    if (char >= '0' && char <= '9') || (char >= 'A' && char <= 'Z') then
        True

    else
        False


hasOnlyAllowedCharacters : String -> Bool
hasOnlyAllowedCharacters configuration =
    let
        nonAlphaNumeric =
            configuration
                |> String.filter
                    (\char -> List.member char [ ' ', '-', '\'' ] || isAlphaNum char)
                |> String.length
    in
    nonAlphaNumeric == String.length configuration


validate : PlateCategory -> String -> Result ValidationError Plate
validate category rawInput =
    let
        normalized =
            normalize rawInput
    in
    if not (isNotEmpty normalized) then
        Err EmptyPlate

    else if not (hasOnlyAllowedCharacters normalized) then
        Err InvalidCharacter

    else if not (hasAtMostOneSeparator normalized) then
        Err TooManySeparators

    else if not (isLegalLength normalized category) then
        Err InvalidLength

    else
        Ok (Plate normalized)


toString : Plate -> String
toString plate =
    case plate of
        Plate str ->
            str
