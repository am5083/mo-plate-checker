let test_available () =
  match Plate_checker.Availability.parse_availability "available" with
  | Ok Plate_checker.Availability.Available ->
      ()
  | Ok Plate_checker.Availability.Unavailable ->
      Alcotest.fail "expected Available, got Unavailable"
  | Error message ->
      Alcotest.fail ("expected Available, got Error: " ^ message)

let test_unavailable () =
  match Plate_checker.Availability.parse_availability "unavailable" with
  | Ok Plate_checker.Availability.Unavailable ->
      ()
  | Ok Plate_checker.Availability.Available ->
      Alcotest.fail "expected Unavailable, got Available"
  | Error message ->
      Alcotest.fail ("expected Unavailable, got Error: " ^ message)

let test_malformed () =
  match Plate_checker.Availability.parse_availability "good plate" with
  | Ok Plate_checker.Availability.Unavailable ->
      Alcotest.fail "expected Malformed plate, got Unavailable"
  | Ok Plate_checker.Availability.Available ->
      Alcotest.fail "expected Malformed plate, got Available"
  | Error "Malformed plate" ->
      ()
  | Error message ->
      Alcotest.fail ("expected Malformed plate, got " ^ message)

let () =
  Alcotest.run "availability"
    [ ( "parse_availability"
      , [ Alcotest.test_case "available" `Quick test_available
        ; Alcotest.test_case "unavailable" `Quick test_unavailable
        ; Alcotest.test_case "malformed" `Quick test_malformed ] ) ]
