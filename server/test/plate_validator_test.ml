let test_six_alphanumerics () =
  match Plate_checker.Plate_validator.validate "ABC123" with
  | Ok () ->
      ()
  | Error _ ->
      Alcotest.fail "expected ABC123 to be valid"
