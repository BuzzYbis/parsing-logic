exception
  Lexer_error of {
    pos : int;
    msg : string;
  }

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

type lexer = {
  s : string;
  mutable cur : int;
  sLen : int;
}

let peek lexer = if lexer.cur < lexer.sLen then Some lexer.s.[lexer.cur] else None

let peek_ahead lexer i =
  if lexer.cur + i < lexer.sLen then Some lexer.s.[lexer.cur + i] else None

let rec span lexer i pred =
  if i < lexer.sLen && pred lexer.s.[i] then span lexer (i + 1) pred else i

(** Advance the lexer in place and return the catched string *)
let take_while lexer pred =
  let j = span lexer lexer.cur pred in
  let lexme = String.sub lexer.s lexer.cur (j - lexer.cur) in
  lexer.cur <- j;
  lexme

let rec skip_wp lexer =
  match peek lexer with
  | Some (' ' | '\t' | '\r' | '\n') ->
      lexer.cur <- lexer.cur + 1;
      skip_wp lexer
  | _ -> ()

let keyword = function
  | "true" -> Some True
  | "false" -> Some False
  | _ -> None

let start_ident = function
  | 'a' .. 'z' | 'A' .. 'Z' | '_' -> true
  | _ -> false

let is_ident = function
  | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' -> true
  | _ -> false

let pos lexer = lexer.cur
let lexer_of_string s = { s; cur = 0; sLen = String.length s }

let next lexer =
  skip_wp lexer;
  match peek lexer with
  | None -> EOF
  | Some c -> (
      match c with
      | '(' ->
          lexer.cur <- lexer.cur + 1;
          LP
      | ')' ->
          lexer.cur <- lexer.cur + 1;
          RP
      | '!' ->
          lexer.cur <- lexer.cur + 1;
          Not
      | '&' ->
          lexer.cur <- lexer.cur + 1;
          And
      | '|' ->
          lexer.cur <- lexer.cur + 1;
          Or
      | '-' -> (
          match peek_ahead lexer 1 with
          | Some '>' ->
              lexer.cur <- lexer.cur + 2;
              Impl
          | Some _ | None ->
              Error.lexer ~pos:lexer.cur ~msg:"expected '>' after '-' to form '->'")
      | '<' -> (
          match (peek_ahead lexer 1, peek_ahead lexer 2) with
          | Some '=', Some '>' ->
              lexer.cur <- lexer.cur + 3;
              Iff
          | Some _, Some _ | Some _, None | None, Some _ | None, None ->
              Error.lexer ~pos:lexer.cur ~msg:"expected '<=>' after '<' to form '<=>'")
      | c -> (
          match start_ident c with
          | true -> (
              let id = take_while lexer is_ident in
              match keyword id with
              | Some b -> b
              | None -> Ident id)
          | false ->
              Error.lexer ~pos:lexer.cur
                ~msg:(Printf.sprintf "unexpected character '%c'" c)))
