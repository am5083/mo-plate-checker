type validation_error =
  | Empty
  | Too_many_alphanumerics
  | Too_many_separators
  | Unsupported_character of char

let is_ascii_alphanumeric character =
  (character >= 'A' && character <= 'Z')
  || (character >= 'a' && character <= 'z')
  || (character >= '0' && character <= '9')

let is_separator character =
  character = ' ' || character = '-' || character = '\''

let rec scan plate position alphanumeric_count separator_count _invalid =
  if position = String.length plate then
    (alphanumeric_count, separator_count, _invalid)
  else
    let character = plate.[position] in
    if is_ascii_alphanumeric character then
      scan plate (position + 1) (alphanumeric_count + 1) separator_count
        _invalid
    else if is_separator character then
      scan plate (position + 1) alphanumeric_count (separator_count + 1)
        _invalid
    else
      scan plate (position + 1) alphanumeric_count separator_count
        (character :: _invalid)

(* validate : string -> (unit, validation_error) result *)
let validate plate =
  let len = String.length plate in
  let alphanum_count, sep_count, invalid = scan plate 0 0 0 [] in
  if len = 0 then Error Empty
  else if not (List.is_empty invalid) then
    Error (Unsupported_character (List.hd invalid))
  else if alphanum_count > 6 then Error Too_many_alphanumerics
  else if sep_count > 1 then Error Too_many_separators
  else Ok ()
