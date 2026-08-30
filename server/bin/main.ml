let () =
  match Plate_checker.Availability.parse_availability "available" with
  | Ok Plate_checker.Availability.Available ->
      print_endline "available"
  | Ok Plate_checker.Availability.Unavailable ->
      print_endline "unavailable"
  | Error message ->
      prerr_endline message
