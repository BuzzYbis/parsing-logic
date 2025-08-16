type kind =
  | Lexer
  | Parser
  | Eval

type param = {
  kind : kind;
  pos : int;
  msg : string;
}

exception E of param

let lexer ~pos ~msg = raise (E { kind = Lexer; pos; msg })
let parser ~pos ~msg = raise (E { kind = Parser; pos; msg })
let eval ~pos ~msg = raise (E { kind = Eval; pos; msg })

let line_col ~src ~pos =
  let len = String.length src in
  let pos = max 0 (min pos len) in
  let rec aux cur line col =
    if cur = pos then (line, col)
    else
      let c = src.[cur] in
      if c = '\n' then aux (cur + 1) (line + 1) col else aux (cur + 1) line (col + 1)
  in
  aux 0 0 1

let render ~src { kind; pos; msg } =
  let prefix =
    match kind with
    | Lexer -> "Lexer error: "
    | Parser -> "Parser error: "
    | Eval -> "Evaluation error: "
  in
  let line, col = line_col ~src ~pos in
  let len = String.length src in
  let rec find_start i =
    if i = 0 then 0 else if src.[i - 1] = '\n' then i else find_start (i - 1)
  in
  let rec find_end j =
    if j >= len then len else if src.[j] = '\n' then j else find_end (j + 1)
  in
  let s = find_start pos in
  let e = find_end pos in
  let error_line = String.sub src s (e - s) in
  Printf.sprintf "%s at %d:%d: %s\n%s\n%*s^\n" prefix line col msg error_line
    (max 0 (col - 1))
    ""
