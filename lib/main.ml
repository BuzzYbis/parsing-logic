let to_result f = try Ok (f ()) with Error.E e -> Error e

let main () =
  let input =
    if Array.length Sys.argv >= 2 then Sys.argv.(1)
    else (
      Printf.printf "Enter propositional formula: ";
      flush stdout;
      read_line ())
  in
  match
    to_result (fun () ->
        let e = Parser.parse input in
        Table.print ~out:stdout ~header:input e)
  with
  | Ok () -> ()
  | Error err ->
      Printf.eprintf "%s\n" (Error.render ~src:input err);
      exit 1
