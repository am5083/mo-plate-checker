module AvailabilityApi exposing
    ( ApiError(..)
    , CheckError(..)
    , CheckResult
    , check
    , decodeResponse
    , errorDecoder
    , resultDecoder
    )

import Availability exposing (Availability(..))
import Http
import Json.Decode as Decode exposing (Decoder)



-- API ERROR


type ApiError
    = InvalidPlate
    | RateLimited
    | UpstreamFailure


errorDecoder : Decoder ApiError
errorDecoder =
    Decode.field "error" Decode.string
        |> Decode.andThen
            (\kind ->
                if kind == "invalid_plate" then
                    Decode.succeed InvalidPlate

                else if kind == "rate_limited" then
                    Decode.succeed RateLimited

                else if kind == "upstream_failure" then
                    Decode.succeed UpstreamFailure

                else
                    Decode.fail "unknown error"
            )



-- CHECK ERROR


type CheckError
    = ApiFailure ApiError
    | HttpFailure Http.Error


decodeResponse : Int -> String -> Result CheckError CheckResult
decodeResponse status response =
    if status <= 299 && status >= 200 then
        case Decode.decodeString resultDecoder response of
            Ok checkResult ->
                Ok checkResult

            Err decodeError ->
                Err
                    (HttpFailure
                        (Http.BadBody
                            (Decode.errorToString decodeError)
                        )
                    )

    else
        case Decode.decodeString errorDecoder response of
            Ok apiError ->
                Err (ApiFailure apiError)

            Err decodeError ->
                Err
                    (HttpFailure
                        (Http.BadBody
                            (Decode.errorToString decodeError)
                        )
                    )


responseToResult : Http.Response String -> Result CheckError CheckResult
responseToResult response =
    case response of
        Http.BadUrl_ url ->
            Err (HttpFailure (Http.BadUrl url))

        Http.Timeout_ ->
            Err (HttpFailure Http.Timeout)

        Http.NetworkError_ ->
            Err (HttpFailure Http.NetworkError)

        Http.BadStatus_ metadata body ->
            decodeResponse metadata.statusCode body

        Http.GoodStatus_ metadata body ->
            decodeResponse metadata.statusCode body


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


check : (Result CheckError CheckResult -> msg) -> Cmd msg
check toMsg =
    Http.get
        { url = "/api/check?plate=AHMED"
        , expect = Http.expectStringResponse toMsg responseToResult
        }
