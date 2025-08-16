(** Error handling for [Parser] and [Lexer] *)

type kind =
  | Lexer
  | Parser
  | Eval

(** Parameter for our error type, [pos] is the index where the error occur in the given
    proposition *)
type param = {
  kind : kind;
  pos : int;
  msg : string;
}

exception E of param

(** [lexer ~pos ~msg], [parser ~pos ~msg] and [eval ~pos ~msg] raise [E] given the
    parameters *)

val lexer : pos:int -> msg:string -> 'a
val parser : pos:int -> msg:string -> 'a
val eval : pos:int -> msg:string -> 'a

(** Convert a [pos] into a 1-based (line, col) in [src] *)
val line_col : src:string -> pos:int -> int * int

(** Pretty-print an error on the source string *)
val render : src:string -> param -> string
