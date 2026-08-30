let check_response expected_status expected_body expected_allow
    (actual : Plate_checker.Http_handler.response) =
  Alcotest.check Alcotest.int "status" expected_status actual.status ;
  Alcotest.check
    (Alcotest.option Alcotest.string)
    "content type" (Some "application/json")
    (List.assoc_opt "content-type" actual.headers) ;
  Alcotest.check Alcotest.string "body" expected_body actual.body ;
  Alcotest.check
    (Alcotest.option Alcotest.string)
    "Allow header" expected_allow
    (List.assoc_opt "allow" actual.headers)

let test_health () =
  let actual = Plate_checker.Http_handler.handle `GET "/api/health" in
  check_response 200 "{\"status\":\"ok\"}" None actual

let test_missing () =
  let actual = Plate_checker.Http_handler.handle `GET "/missing" in
  check_response 404 "{\"error\":\"not_found\"}" None actual

let test_post () =
  let actual = Plate_checker.Http_handler.handle `POST "/api/health" in
  check_response 405 "{\"error\":\"method_not_allowed\"}" (Some "GET") actual

let () =
  Alcotest.run "http_handler"
    [ ( "check /api/health"
      , [ Alcotest.test_case "GET" `Quick test_health
        ; Alcotest.test_case "MISSING" `Quick test_missing
        ; Alcotest.test_case "POST" `Quick test_post ] ) ]
