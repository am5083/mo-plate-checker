module AvailabilityApiTest exposing (suite)

import Availability exposing (Availability(..))
import AvailabilityApi
import Expect
import Http
import Json.Decode as Decode
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "AvailabilityApi Decoders"
        [ test "decodes an available plate" <|
            \_ ->
                Decode.decodeString
                    AvailabilityApi.resultDecoder
                    """{ "plate": "AHMED", "available": true } """
                    |> Expect.equal
                        (Ok
                            { plate = "AHMED"
                            , availability = Available
                            }
                        )
        , test "decodes an unavailable plate" <|
            \_ ->
                Decode.decodeString
                    AvailabilityApi.resultDecoder
                    """{ "plate": "AHMED", "available": false } """
                    |> Expect.equal
                        (Ok
                            { plate = "AHMED"
                            , availability = Unavailable
                            }
                        )
        , test "rejects a non-Boolean available field" <|
            \_ ->
                Decode.decodeString
                    AvailabilityApi.resultDecoder
                    """{ "plate": "AHMED", "available": "yes" }"""
                    |> Expect.err
        , test "decodes invalid_plate" <|
            \_ ->
                Decode.decodeString
                    AvailabilityApi.errorDecoder
                    """{ "error": "invalid_plate" }"""
                    |> Expect.equal (Ok AvailabilityApi.InvalidPlate)
        , test "decodes rate_limited" <|
            \_ ->
                Decode.decodeString
                    AvailabilityApi.errorDecoder
                    """{ "error": "rate_limited" }"""
                    |> Expect.equal (Ok AvailabilityApi.RateLimited)
        , test "decodes upstream_failure" <|
            \_ ->
                Decode.decodeString
                    AvailabilityApi.errorDecoder
                    """{ "error": "upstream_failure" }"""
                    |> Expect.equal (Ok AvailabilityApi.UpstreamFailure)
        , test "intereprets a 429 response as a rate-limit failure" <|
            \_ ->
                AvailabilityApi.decodeResponse
                    429
                    """{ "error": "rate_limited" } """
                    |> Expect.equal
                        (Err
                            (AvailabilityApi.ApiFailure
                                AvailabilityApi.RateLimited
                            )
                        )
        , test "intereprets a 502 response as an upstream failure" <|
            \_ ->
                AvailabilityApi.decodeResponse
                    502
                    """{ "error": "upstream_failure" } """
                    |> Expect.equal
                        (Err
                            (AvailabilityApi.ApiFailure
                                AvailabilityApi.UpstreamFailure
                            )
                        )
        , test "interperts a malformed 200 response as BadBody" <|
            \_ ->
                case
                    AvailabilityApi.decodeResponse
                        200
                        """{ "plate": "AHMED", "available": "yes" }"""
                of
                    Err (AvailabilityApi.HttpFailure (Http.BadBody _)) ->
                        Expect.pass

                    _ ->
                        Expect.fail "Expected HttpFailure with BadBody"
        , test "interperts a correctly formed 200 response" <|
            \_ ->
                AvailabilityApi.decodeResponse
                    200
                    """{ "plate": "AHMED", "available": true }"""
                    |> Expect.equal
                        (Ok
                            { plate = "AHMED"
                            , availability = Availability.Available
                            }
                        )
        ]
