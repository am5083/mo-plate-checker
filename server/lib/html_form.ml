let hidden_inputs html =
  Soup.parse html
  |> Soup.select "input[type=hidden]"
  |> Soup.fold
       (fun fields input ->
         match Soup.attribute "name" input with
         | None ->
             fields
         | Some name ->
             let value =
               match Soup.attribute "value" input with
               | Some value ->
                   value
               | None ->
                   ""
             in
             (name, value) :: fields )
       []
  |> List.rev
