module AvailabilityApi exposing (CheckResult, check, resultDecoder)

import Availability exposing (Availability(..))
import Http
import Json.Decode as Decode exposing (Decoder)


type alias CheckResult =
    { plate : String
    , availability : Availability
    }


availabilityFromBool : Bool -> Availability
availabilityFromBool value =
    if value then
        Available

    else
        Unavailable


resultDecoder : Decoder CheckResult
resultDecoder =
    Decode.map2 CheckResult
        (Decode.field "plate" Decode.string)
        (Decode.map availabilityFromBool
            (Decode.field "available" Decode.bool)
        )


check : (Result Http.Error CheckResult -> msg) -> Cmd msg
check toMsg =
    Http.get
        { url = "/api/check?plate=AHMED"
        , expect = Http.expectJson toMsg resultDecoder
        }
