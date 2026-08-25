module Plate exposing (Plate, normalize)

-- PLATE


type alias Plate =
    { text : String
    }


normalize : String -> String
normalize str =
    String.trim (String.toUpper str)
