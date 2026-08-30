let port =
  match Sys.getenv_opt "PORT" with
  | None ->
      8080
  | Some value -> (
    match int_of_string_opt value with
    | Some port when port > 0 && port <= 65535 ->
        port
    | _ ->
        failwith "PORT must be an integer from 1 to 65535" )

let handler _connection request _body =
  match (Http.Request.meth request, Http.Request.resource request) with
  | `GET, "/api/health" ->
      Cohttp_eio.Server.respond_string
        ~headers:(Http.Header.of_list [("content-type", "application/json")])
        ~status:`OK ~body:"{\"status\":\"ok\"}" ()
  | _ ->
      Cohttp_eio.Server.respond_string ~status:`Not_found ~body:"" ()

let () =
  Eio_main.run (fun env ->
      Eio.Switch.run (fun sw ->
          let socket =
            Eio.Net.listen env#net ~sw ~backlog:128 ~reuse_addr:true
              (`Tcp (Eio.Net.Ipaddr.V4.loopback, port))
          in
          let server = Cohttp_eio.Server.make ~callback:handler () in
          Printf.printf "Listening on http://127.0.0.1:%d\n%!" port ;
          Cohttp_eio.Server.run socket server ~on_error:raise ) )
