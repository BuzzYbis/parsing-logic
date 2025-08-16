module M = Map.Make (String)

let map_of_list lst = List.to_seq lst |> M.of_seq

let rec eval_mapped_input map = function
  | Ast.Var v -> (
      match M.find_opt v map with
      | Some b -> b
      | None -> Error.eval ~pos:0 ~msg:("unbound variable " ^ v))
  | Ast.Const b -> b
  | Ast.Not expr -> not (eval_mapped_input map expr)
  | Ast.Bin (op, l, r) ->
      let f = Ast.bop_evaluator op in
      f (eval_mapped_input map l) (eval_mapped_input map r)

let eval input_map expr = eval_mapped_input (map_of_list input_map) expr
