(** Truth table rendering. *)

(** [print header out expr] print the truth table (header, all valuation rows and there
    result) to the [out] channel *)
val print : header:string -> out:out_channel -> Ast.expr -> unit
