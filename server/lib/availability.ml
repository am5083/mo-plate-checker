type availability = Available | Unavailable

let parse_availability av =
  match av with
  | "available" ->
      Ok Available
  | "unavailable" ->
      Ok Unavailable
  | _ ->
      Error "Malformed plate"
