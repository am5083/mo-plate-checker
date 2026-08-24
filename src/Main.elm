module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onFocus, onInput)



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
    div []
        [ h1 [] [ text "MO Plate Checker" ]
        , p [] [ text model.seed ]
        , seedInput model.seed SeedChange
        ]


viewInput : String -> String -> String -> Int -> (String -> msg) -> Html msg
viewInput t v p mc toMsg =
    input [ type_ t, value v, placeholder p, maxlength mc, onInput toMsg ] []


seedInput : String -> (String -> msg) -> Html msg
seedInput seed toMsg =
    viewInput "text" seed seed 6 toMsg
