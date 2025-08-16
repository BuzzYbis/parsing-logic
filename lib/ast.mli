(** Abstract syntax tree for propositional logic *)

(** Represent our binary operator *)
type bop

(** Canonical values for our binary operator. This make our binary operator carrying its
    own information. *)

val op_and : bop
val op_or : bop
val op_impl : bop
val op_iff : bop

(** Minimal operator queries for Parser *)

val bop_prec : bop -> int
val is_bop_right_assoc : bop -> bool
val bop_symbol : bop -> string
val bop_evaluator : bop -> bool -> bool -> bool
val not_prec : int

(** Expression for propositional logic *)
type expr =
  | Var of string
  | Const of bool
  | Not of expr
  | Bin of bop * expr * expr

(** Give the internal precedence of an expression *)
val precedence : expr -> int

(** Give the sorted list of variable in the proposition *)
val vars : expr -> string list

(** Pretty print expression with minimal parenthesis *)
val pp : expr -> string
