type response = {status: int; headers: (string * string) list; body: string}

let json_response status extra_headers body =
  {status; headers= ("content-type", "application/json") :: extra_headers; body}

let respond_health = json_response 200 [] "{\"status\":\"ok\"}"

let respond_404 = json_response 404 [] "{\"error\":\"not_found\"}"

let respond_405 =
  json_response 405 [("allow", "GET")] "{\"error\":\"method_not_allowed\"}"

let handle meth path =
  match (meth, path) with
  | `GET, "/api/health" ->
      respond_health
  | _, "/api/health" ->
      respond_405
  | _ ->
      respond_404
