open Plate_checker.Plate_validator

let test_invalid_skips_request () =
  let calls = ref 0 in
  let request plate =
    calls := !calls + 1 ;
    plate
  in
  let actual = Plate_checker.Dor_client.check request "ABC1234" in
  Alcotest.check Alcotest.int "callback calls" 0 !calls ;
  Alcotest.check Alcotest.bool "validation result" true
    (actual = Error Too_many_alphanumerics)

let test_valid_calls_request () =
  let calls = ref 0 in
  let request plate =
    calls := !calls + 1 ;
    plate
  in
  let actual = Plate_checker.Dor_client.check request "ABC123" in
  Alcotest.check Alcotest.int "callback calls" 1 !calls ;
  Alcotest.check Alcotest.bool "validation result" true (actual = Ok "ABC123")

let () =
  Alcotest.run "dor client"
    [ ( "test dor client"
      , [ Alcotest.test_case "ABC1234" `Quick test_invalid_skips_request
        ; Alcotest.test_case "ABC123" `Quick test_valid_calls_request ] ) ]
