module Variations exposing (deleteAt, deleteInterior, interiorIndexes, repeatFinal, replaceInteriorWithDash, reverseSeed)


repeatFinal : String -> Maybe String
repeatFinal seed =
    if String.isEmpty seed then
        Nothing

    else
        -- String.right 1 seed extracts the last `1` character from the right in `seed`
        Just (seed ++ String.right 1 seed)


reverseSeed : String -> Maybe String
reverseSeed seed =
    if String.isEmpty seed then
        Nothing

    else
        Just (String.reverse seed)


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
