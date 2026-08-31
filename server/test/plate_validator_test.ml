open Plate_checker.Plate_validator

let check_plate plate expected =
  let actual = Plate_checker.Plate_validator.validate plate in
  Alcotest.check Alcotest.bool plate true (actual = expected)

let test_six_alphanumerics () =
  check_plate "ABC123" (Ok ()) ;
  check_plate "ABC 123" (Ok ()) ;
  check_plate "ABC-123" (Ok ()) ;
  check_plate "ABC'123" (Ok ()) ;
  check_plate "ABC1234"
    (Error Plate_checker.Plate_validator.Too_many_alphanumerics) ;
  check_plate "K-5D-5" (Error Too_many_separators) ;
  check_plate "ABC_12" (Error (Unsupported_character '_')) ;
  check_plate "" (Error Empty)

let () =
  Alcotest.run "plate_validator"
    [ ( "check plate_validator for correctness"
      , [ Alcotest.test_case "test_six_alphanumerics" `Quick
            test_six_alphanumerics ] ) ]
