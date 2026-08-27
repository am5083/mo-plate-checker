module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onFocus, onInput)
import Plate
import Variations



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { seed : String
    }


init : Model
init =
    Model "AHMED"



-- UPDATE


type Msg
    = SeedChange String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SeedChange newSeed ->
            { model | seed = newSeed }



-- VIEW


view : Model -> Html Msg
view model =
    let
        variations =
            Variations.generate Plate.Regular model.seed

        normalizedSeed =
            Plate.normalize model.seed
    in
    div []
        [ h1 [] [ text "MO Plate Checker" ]
        , p [] [ text ("Normalized seed: " ++ normalizedSeed) ]
        , label [ for "seed-input" ] [ text "Plate Seed: " ]
        , seedInput model.seed SeedChange
        , viewVariations variations
        ]


viewVariations :
    Result Plate.ValidationError (List Plate.Plate)
    -> Html msg
viewVariations result =
    case result of
        Err r ->
            p [] [ text (validationErrorMessage r) ]

        Ok [] ->
            p [] [ text "no candidates exist" ]

        Ok plates ->
            ul [] (List.map viewPlate plates)


viewPlate : Plate.Plate -> Html msg
viewPlate plate =
    let
        cand =
            Plate.toString plate
    in
    li [] [ text cand ]


viewInput : String -> String -> String -> String -> Int -> (String -> msg) -> Html msg
viewInput l t v p mc toMsg =
    input [ id l, type_ t, value v, placeholder p, maxlength mc, onInput toMsg ] []


seedInput : String -> (String -> msg) -> Html msg
seedInput seed toMsg =
    viewInput "seed-input" "text" seed seed 6 toMsg


validationErrorMessage : Plate.ValidationError -> String
validationErrorMessage valError =
    case valError of
        Plate.EmptyPlate ->
            "plate is empty"

        Plate.InvalidCharacter ->
            "invalid character"

        Plate.TooManySeparators ->
            "too many separators; only 1 is allowed per plate"

        Plate.InvalidLength ->
            "invalid length; plate too long"
