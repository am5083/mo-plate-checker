let endpoint =
  Uri.of_string "https://sa.dor.mo.gov/mv/plates4u/PlateInformation"

let max_body_bytes = 1_048_576

let tls_config () =
  let authenticator =
    match Ca_certs.authenticator () with
    | Ok authenticator ->
        authenticator
    | Error (`Msg message) ->
        failwith ("system CA configuration failed: " ^ message)
  in
  match Tls.Config.client ~authenticator () with
  | Ok config ->
      config
  | Error (`Msg message) ->
      failwith ("TLS configuration failed: " ^ message)

let https config uri raw_flow =
  let host =
    match Uri.host uri with
    | Some hostname ->
        Domain_name.(host_exn (of_string_exn hostname))
    | None ->
        invalid_arg "HTTPS URI has no host"
  in
  Tls_eio.client_of_flow ~host config raw_flow

let fetch_bootstrap ~net =
  Mirage_crypto_rng_unix.use_default () ;
  Eio.Switch.run
  @@ fun sw ->
  let client =
    Cohttp_eio.Client.make ~https:(Some (https (tls_config ()))) net
  in
  let response, body = Cohttp_eio.Client.get ~sw client endpoint in
  let body = Eio.Buf_read.(parse_exn take_all) body ~max_size:max_body_bytes in
  Dor_bootstrap.process_response
    ~status:(Http.Status.to_int response.status)
    ~headers:response.headers ~body
