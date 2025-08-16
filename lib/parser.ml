type state = {
  lexer : Lexer.lexer;
  mutable token : Lexer.token;
}

let next state = state.token <- Lexer.next state.lexer

let bop_lexer_to_ast = function
  | Lexer.And -> Some Ast.op_and
  | Lexer.Or -> Some Ast.op_or
  | Lexer.Impl -> Some Ast.op_impl
  | Lexer.Iff -> Some Ast.op_iff
  | _ -> None

let get_op_prec token =
  match bop_lexer_to_ast token with
  | Some op -> Ast.bop_prec op
  | None -> 0

let rec parse_prefix state =
  match state.token with
  | Lexer.Ident v ->
      next state;
      Ast.Var v
  | Lexer.True ->
      next state;
      Ast.Const true
  | Lexer.False ->
      next state;
      Ast.Const false
  | Lexer.Not ->
      next state;
      Ast.Not (parse_expr state Ast.not_prec)
  | Lexer.LP ->
      next state;
      let expr = parse_expr state 0 in
      (match state.token with
      | Lexer.RP -> next state
      | _ -> Error.parser ~pos:(Lexer.pos state.lexer) ~msg:"expected ')'");
      expr
  | _ -> Error.parser ~pos:(Lexer.pos state.lexer) ~msg:"expected term"

and parse_infix state left =
  match bop_lexer_to_ast state.token with
  | Some op ->
      next state;
      let prec = Ast.bop_prec op in
      let expr_prec = if Ast.is_bop_right_assoc op then prec - 1 else prec in
      let right = parse_expr state expr_prec in
      Ast.Bin (op, left, right)
  | None -> left

and parse_expr state expr_prec =
  let left = parse_prefix state in
  let rec find_leftmost left =
    match state.token with
    | (Lexer.And | Lexer.Or | Lexer.Impl | Lexer.Iff) as op
      when get_op_prec op > expr_prec ->
        let left' = parse_infix state left in
        find_leftmost left'
    | _ -> left
  in
  find_leftmost left

let parse s =
  let lexer = Lexer.lexer_of_string s in
  let state = { lexer; token = Lexer.next lexer } in
  let expr = parse_expr state 0 in
  (match state.token with
  | Lexer.EOF -> ()
  | token ->
      let msg =
        match token with
        | Lexer.LP -> "unexpected '('"
        | Lexer.RP -> "unexpected ')'"
        | Lexer.Ident v -> "trailing ident '" ^ v ^ "'"
        | Lexer.True | Lexer.False -> "trailing const"
        | Lexer.Not -> "trailing prefic operator"
        | Lexer.And | Lexer.Or | Lexer.Impl | Lexer.Iff -> "trailing operator"
        | Lexer.EOF -> failwith "unreachable"
      in
      Error.parser ~pos:(Lexer.pos state.lexer) ~msg);
  expr
