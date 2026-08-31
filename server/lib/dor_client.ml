(* (string -> 'response) *)
(* -> string *)
(* -> ('response, validation_error) result*)

(* If plate passes validation, request the plate from API, otherwise if it fails validation error, throw that before making the request *)
let check request plate =
  match Plate_validator.validate plate with
  | Error validation_error ->
      Error validation_error
  | Ok () ->
      Ok (request plate)
