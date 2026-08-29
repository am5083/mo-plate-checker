module Main exposing (..)

import Availability
import AvailabilityApi
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onFocus, onInput)
import Plate
import Variations



-- REQUEST LIFECYCLE


type RequestLifecycle
    = NotRequested
    | Loading
    | Success Availability.Availability
    | Fail String



-- MAIN


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MODEL


type alias Model =
    { seed : String
    , lifecycle : RequestLifecycle
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "AHMED" NotRequested
    , Cmd.none
    )



-- UPDATE


type Msg
    = SeedChange String
    | CheckAvailability
    | GotAvailability (Result AvailabilityApi.CheckError AvailabilityApi.CheckResult)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SeedChange newSeed ->
            ( { model | seed = newSeed }
            , Cmd.none
            )

        CheckAvailability ->
            case model.lifecycle of
                Loading ->
                    ( model, Cmd.none )

                _ ->
                    ( { model | lifecycle = Loading }
                    , AvailabilityApi.check GotAvailability
                    )

        GotAvailability result ->
            case result of
                Ok checkResult ->
                    ( { model | lifecycle = Success checkResult.availability }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | lifecycle = Fail "Availability check failed" }
                    , Cmd.none
                    )



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
        , button [ onClick CheckAvailability ] [ text "Check fixed AHMED response" ]
        , viewAvailability model.lifecycle
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


viewAvailability : RequestLifecycle -> Html msg
viewAvailability lifecycle =
    case lifecycle of
        NotRequested ->
            text ""

        Loading ->
            p [] [ text "Checking..." ]

        Success Availability.Available ->
            p [] [ text "AHMED is available" ]

        Success Availability.Unavailable ->
            p [] [ text "AHMED is unavailable" ]

        Fail message ->
            p [] [ text message ]


viewInput : String -> String -> String -> String -> (String -> msg) -> Html msg
viewInput l t v p toMsg =
    input [ id l, type_ t, value v, placeholder p, onInput toMsg ] []


seedInput : String -> (String -> msg) -> Html msg
seedInput seed toMsg =
    viewInput "seed-input" "text" seed seed toMsg


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
