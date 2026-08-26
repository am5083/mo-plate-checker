module Variations exposing (deleteAt, interiorIndexes, repeatFinal, reverseSeed)


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


deleteAt : Int -> String -> String
deleteAt index seed =
    String.left index seed
        ++ String.dropLeft (index + 1) seed


deleteInterior : String -> List String
deleteInterior seed =
    interiorIndexes seed
        |> List.map (\index -> deleteAt index seed)
