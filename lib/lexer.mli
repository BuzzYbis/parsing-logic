(** Simple lexer for propositional logic *)

(** [Lexer_error {pos; msg}] indicates a syntax error at index [pos]. *)
exception
  Lexer_error of {
    pos : int;
    msg : string;
  }

(** Type representing a token *)
type token =
  | LP
  | RP
  | Not
  | And
  | Or
  | Impl
  | Iff
  | True
  | False
  | Ident of string
  | EOF

(** Lexer type used to tokenize our input string *)
type lexer

(** Give the current position in the input string (0-indexed) *)
val pos : lexer -> int

(** Create a lexer from a string *)
val lexer_of_string : string -> lexer

(** Return the next token of our lexer, skipping whitespaces
    @raise Error.E
      with [kind = Lexer] when encountering incorrect characters or malformed operators *)
val next : lexer -> token
