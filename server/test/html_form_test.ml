open Plate_checker.Html_form

let test_hidden_inputs () =
  let html =
    {|
      <form>
        <input type="hidden" name="state_one" value="placeholder-a">
        <input type="text" name="plate" value="VISIBLE">
        <input type="hidden" name="state_two" value="">
        <input type="hidden" value="unnamed">
      </form>
    |}
  in
  let actual = hidden_inputs html in
  let expected = [("state_one", "placeholder-a"); ("state_two", "")] in
  Alcotest.check Alcotest.bool "named hidden inputs" true (actual = expected)

let () =
  Alcotest.run "html_form"
    [ ( "hidden inputs"
      , [ Alcotest.test_case "extracts named hidden fields" `Quick
            test_hidden_inputs ] ) ]
