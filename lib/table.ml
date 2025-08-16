let rows expr =
  let vs = Ast.vars expr in
  let n = List.length vs in
  if n = 0 then (vs, [ ([], Eval.eval [] expr) ])
  else
    let total = 1 lsl n in
    let rs = ref [] in
    let vs_arr = Array.of_list vs in
    for mask = total - 1 downto 0 do
      let val_rev = ref [] in
      for i = 0 to n - 1 do
        let v = vs_arr.(i) in
        let bit = (mask lsr (n - 1 - i)) land 1 = 1 in
        val_rev := (v, bit) :: !val_rev
      done;
      let valuation = List.rev !val_rev in
      let res = Eval.eval valuation expr in
      rs := (valuation, res) :: !rs
    done;
    (vs, !rs)

let print ~header ~out expr =
  let vs, rs = rows expr in
  List.iter (fun v -> Printf.fprintf out "%s " v) vs;
  Printf.fprintf out "| %s\n" header;
  List.iter
    (fun (env, res) ->
      List.iter (fun (_v, b) -> Printf.fprintf out "%d " (if b then 1 else 0)) env;
      Printf.fprintf out "| %d\n" (if res then 1 else 0))
    rs
