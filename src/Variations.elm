module Variations exposing (deleteAt, deleteInterior, generate, insertInteriorDashes, interiorIndexes, rawCandidates, repeatFinal, replaceInteriorWithDash, reverseSeed, stableUnique)

import Plate



-- TODO: Add more later, once I have a frontend/backend; these will do for now.


repeatFinal : String -> List String
repeatFinal seed =
    if String.isEmpty seed then
        []

    else
        -- String.right 1 seed extracts the last `1` character from the right in `seed`
        [ seed ++ String.right 1 seed ]


reverseSeed : String -> List String
reverseSeed seed =
    if String.isEmpty seed then
        []

    else
        [ String.reverse seed ]


interiorIndexes : String -> List Int
interiorIndexes seed =
    List.range 1 (String.length seed - 2)


deleteInterior : String -> List String
deleteInterior seed =
    interiorIndexes seed
        |> List.map (\index -> deleteAt index seed)


replaceAt : Int -> String -> String -> String
replaceAt index replacement seed =
    String.left index seed
        ++ replacement
        ++ String.dropLeft (index + 1) seed


deleteAt : Int -> String -> String
deleteAt index seed =
    replaceAt index "" seed


replaceInteriorWithDash : String -> List String
replaceInteriorWithDash seed =
    interiorIndexes seed
        |> List.map (\index -> replaceAt index "-" seed)


replaceInteriorWithSpace : String -> List String
replaceInteriorWithSpace seed =
    interiorIndexes seed
        |> List.map (\index -> replaceAt index " " seed)


replaceInteriorWithApostrophe : String -> List String
replaceInteriorWithApostrophe seed =
    interiorIndexes seed
        |> List.map (\index -> replaceAt index "'" seed)


insertionIndexes : String -> List Int
insertionIndexes seed =
    List.range 1 (String.length seed - 1)


insertAt : Int -> String -> String -> String
insertAt index insertion seed =
    String.left index seed
        ++ insertion
        ++ String.dropLeft index seed


insertInteriorDashes : String -> List String
insertInteriorDashes seed =
    insertionIndexes seed
        |> List.map (\index -> insertAt index "-" seed)


insertInteriorSpaces : String -> List String
insertInteriorSpaces seed =
    insertionIndexes seed
        |> List.map (\index -> insertAt index " " seed)


insertInteriorApostrophes : String -> List String
insertInteriorApostrophes seed =
    insertionIndexes seed
        |> List.map (\index -> insertAt index "'" seed)


rawCandidates : String -> List String
rawCandidates seed =
    [ repeatFinal, reverseSeed, deleteInterior, replaceInteriorWithDash, replaceInteriorWithSpace, replaceInteriorWithApostrophe, insertInteriorDashes, insertInteriorSpaces, insertInteriorApostrophes ]
        |> List.concatMap (\func -> func seed)


generate : Plate.PlateCategory -> String -> Result Plate.ValidationError (List Plate.Plate)
generate category rawSeed =
    case Plate.validate category rawSeed of
        Err error ->
            Err error

        Ok plate ->
            let
                seed =
                    Plate.toString plate
            in
            rawCandidates seed
                |> List.filter (\candidate -> candidate /= seed)
                |> stableUnique
                |> List.filterMap (validateCandidate category)
                |> Ok


validateCandidate :
    Plate.PlateCategory
    -> String
    -> Maybe Plate.Plate
validateCandidate category candidate =
    case Plate.validate category candidate of
        Err _ ->
            Nothing

        Ok plate ->
            Just plate


stableUnique : List String -> List String
stableUnique candidates =
    List.foldl
        (\candidate kept ->
            if List.member candidate kept then
                kept

            else
                kept ++ [ candidate ]
        )
        []
        candidates
