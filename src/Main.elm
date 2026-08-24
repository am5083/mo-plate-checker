module Main exposing (..)

import Browser
import Html exposing (..)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { seed : String }


init : Model
init =
    Model ""



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
    div []
        [ h1 [] [ text "MO Plate Checker" ] ]
