(** Evaluation of a proposition *)

(** [eval var_map expr] evaluate an [expr] under [var_map]
    @raise Error.E with [kind = Eval] if finding and unbounded value in [var_map] *)
val eval : (string * bool) list -> Ast.expr -> bool
