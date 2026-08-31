open Plate_checker.Plate_validator

let test_invalid_skips_request () =
  let calls = ref 0 in
  let request plate =
    calls := !calls + 1 ;
    Ok plate
  in
  let actual = Plate_checker.Dor_client.check request "ABC1234" in
  Alcotest.check Alcotest.int "callback calls" 0 !calls ;
  Alcotest.check Alcotest.bool "validation result" true
    ( actual
    = Error (Plate_checker.Dor_client.Validation_failure Too_many_alphanumerics)
    )

let test_valid_calls_request () =
  let calls = ref 0 in
  let request plate =
    calls := !calls + 1 ;
    Ok plate
  in
  let actual = Plate_checker.Dor_client.check request "ABC123" in
  Alcotest.check Alcotest.int "callback calls" 1 !calls ;
  Alcotest.check Alcotest.bool "validation result" true (actual = Ok "ABC123")

let test_valid_request_failure () =
  let calls = ref 0 in
  let request _plate =
    calls := !calls + 1 ;
    Error "offline request failure"
  in
  let actual = Plate_checker.Dor_client.check request "ABC123" in
  Alcotest.check Alcotest.int "valid request failure" 1 !calls ;
  Alcotest.check Alcotest.bool "validation result" true
    ( actual
    = Error (Plate_checker.Dor_client.Request_failure "offline request failure")
    )

let () =
  Alcotest.run "dor client"
    [ ( "test dor client"
      , [ Alcotest.test_case "Test invalid plate - skips request" `Quick
            test_invalid_skips_request
        ; Alcotest.test_case "Test valid call - requests from DOR" `Quick
            test_valid_calls_request
        ; Alcotest.test_case "Test valid request - offline failure" `Quick
            test_valid_request_failure ] ) ]
