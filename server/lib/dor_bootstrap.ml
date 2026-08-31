type state =
  { set_cookies: (string * Cohttp.Cookie.Set_cookie_hdr.t) list
  ; hidden_fields: (string * string) list }

type error = Unexpected_status of int | Missing_hidden_state

let process_response ~status ~headers ~body =
  if not (Cohttp.Code.is_success status) then Error (Unexpected_status status)
  else
    let hidden_fields = Html_form.hidden_inputs body in
    if hidden_fields = [] then Error Missing_hidden_state
    else
      Ok
        { set_cookies= Cohttp.Cookie.Set_cookie_hdr.extract headers
        ; hidden_fields }
