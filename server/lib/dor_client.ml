type 'request_error error =
  | Validation_failure of Plate_validator.validation_error
  | Request_failure of 'request_error

let check request plate =
  match Plate_validator.validate plate with
  | Error validation_error ->
      Error (Validation_failure validation_error)
  | Ok () -> (
    match request plate with
    | Ok response ->
        Ok response
    | Error request_error ->
        Error (Request_failure request_error) )
