open Plate_checker.Dor_bootstrap

let test_process_response () =
  let headers =
    Cohttp.Header.of_list
      [("set-cookie", "session=placeholder-cookie; Path=/form; HttpOnly")]
  in
  let html =
    {|
      <form>
        <input type="hidden" name="state_one" value="placeholder-a">
        <input type="hidden" name="state_two" value="">
        <input type="text" name="plate" value="VISIBLE">
      </form>
    |}
  in
  let expected_cookie =
    Cohttp.Cookie.Set_cookie_hdr.make ~path:"/form" ~http_only:true
      ("session", "placeholder-cookie")
  in
  let success = process_response ~status:200 ~headers ~body:html in
  let expected_success =
    Ok
      { set_cookies= [("session", expected_cookie)]
      ; hidden_fields= [("state_one", "placeholder-a"); ("state_two", "")] }
  in
  Alcotest.check Alcotest.bool "successful bootstrap" true
    (success = expected_success) ;
  let status_failure = process_response ~status:503 ~headers ~body:html in
  Alcotest.check Alcotest.bool "non-success status" true
    (status_failure = Error (Unexpected_status 503)) ;
  let missing_state =
    process_response ~status:200 ~headers
      ~body:{|<input type="text" name="plate" value="VISIBLE">|}
  in
  Alcotest.check Alcotest.bool "missing hidden state" true
    (missing_state = Error Missing_hidden_state)

let () =
  Alcotest.run "dor_bootstrap"
    [ ( "process response"
      , [Alcotest.test_case "bootstrap outcomes" `Quick test_process_response]
      ) ]
