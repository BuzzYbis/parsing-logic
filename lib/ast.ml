type bop_info = {
  prec : int;
  right_assoc : bool;
  symbol : string;
  eval : bool -> bool -> bool;
}

type bop =
  | And of bop_info
  | Or of bop_info
  | Impl of bop_info
  | Iff of bop_info

let op_and = And { prec = 4; right_assoc = false; symbol = "&"; eval = ( && ) }
let op_or = Or { prec = 3; right_assoc = false; symbol = "|"; eval = ( || ) }

let op_impl =
  Impl { prec = 2; right_assoc = true; symbol = "->"; eval = (fun a b -> (not a) || b) }

let op_iff = Iff { prec = 1; right_assoc = true; symbol = "<=>"; eval = Bool.equal }
let not_prec = 5

let info = function
  | And i | Or i | Impl i | Iff i -> i

let bop_prec bop = (info bop).prec
let is_bop_right_assoc bop = (info bop).right_assoc
let bop_symbol bop = (info bop).symbol
let bop_evaluator bop = (info bop).eval

type expr =
  | Var of string
  | Const of bool
  | Not of expr
  | Bin of bop * expr * expr

let precedence = function
  | Bin (op, _, _) -> bop_prec op
  | Not _ -> not_prec
  | Var _ | Const _ -> 6

module S = Set.Make (String)

let vars expr =
  let rec go acc = function
    | Var v -> S.add v acc
    | Const _ -> acc
    | Not e -> go acc e
    | Bin (_, l, r) -> go (go acc l) r
  in
  S.elements (go S.empty expr)

let rec pp = function
  | Var v -> v
  | Const true -> "true"
  | Const false -> "false"
  | Not expr -> Printf.sprintf "!%s" (pp_paren expr 5)
  | Bin (op, l, r) ->
      let p = bop_prec op in
      let sym = bop_symbol op in
      Printf.sprintf "%s %s %s" (pp_paren l p) sym (pp_paren r p)

and pp_paren expr prec =
  let s = pp expr in
  if precedence expr < prec then Printf.sprintf "(%s)" s else s
