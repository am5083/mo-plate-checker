module AvailabilityApiTest exposing (suite)

import Availability exposing (Availability(..))
import AvailabilityApi
import Expect
import Json.Decode as Decode
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "AvailabilityApi.resultDecoder"
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
        ]
