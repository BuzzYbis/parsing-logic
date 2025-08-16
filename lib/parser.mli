(** Pratt parser for a propositionnal logic expression that return an [Ast.expr] given the
    input as string *)

(** [parse s] parses a single expression from [s]
    @raise Error.E with [kind = Parser] when encountering syntax errors *)
val parse : string -> Ast.expr
