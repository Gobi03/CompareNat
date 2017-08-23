include NatCalc
open Printf

(*** DSL ***)
(** syntax **)
type exp = Plus of nat * nat    (* _0 plus _1 *)
         | Times of nat * nat   (* _0 times _1 *)
type prop = Eq of exp * nat     (* _0 is _1 *)
          | LessThan of nat * nat (* _0 is less than _1 *)


(** 処理系 **)
let string_of_exp: exp -> string = function
  | Plus (n, m) ->
    let (ns, ms) = (string_of_nat n, string_of_nat m) in
    sprintf "%s plus %s" ns ms
  | Times (n, m) ->
    let (ns, ms) = (string_of_nat n, string_of_nat m) in
    sprintf "%s times %s" ns ms

let exp_run: exp -> nat = function
  | Plus (n, m) -> plus n m
  | Times (n, m) -> times n m


let paren: string -> string -> string -> string =
  fun indent node subtreestr ->
    sprintf "%s%s {\n%s\n%s}" indent node subtreestr indent


(* AST *)
module CompNat1 = struct
  type derive_tree =
      PZero of nat                              (* Z plus _0 is _0 *)
    | PSucc of (nat * nat * nat) * derive_tree (* (_0 plus _1 is _2) と部分木 *)
    | TZero of nat                              (* Z times n is Z *)
    | TSucc of (nat * nat * nat) * (derive_tree * derive_tree)  (* [_0 times _1 is n3; _1 plus n3 is _2] と部分木の組 *)
    | LSucc of nat                              (* _0 is less than S(_0) *)
    | LTrans of (nat * nat) * (derive_tree * derive_tree)       (* _0 is less than _1 *)

  let rec gen_eqtree: exp -> nat -> derive_tree = fun left right ->
    match (left, right) with
    | (Plus(Z, n), right') ->
      if n = right' then PZero n
      else failwith "not equal"
    | (Plus(S n1, n2), Z) -> failwith "not equal"
    | (Plus(S n1, n2), S n3) ->
      PSucc ((S n1, n2, S n3), gen_eqtree (Plus (n1, n2)) n3)
    | (Times(Z, n), Z) -> TZero n
    | (Times(Z, n), S _) -> failwith "not equal"
    | (Times (S n1, n2), n4) ->
      let n3 =
        let res = minus n4 n2 in (
          match res with
          | None -> failwith "not equal"
          | Some res' -> res'
        ) in
      let nextl = gen_eqtree (Times(n1, n2)) n3
      and nextr = gen_eqtree (Plus(n2, n3)) n4
      in TSucc ((S n1, n2, n4), (nextl, nextr))

  let rec gen_lttree: nat -> nat -> derive_tree = fun left right ->
    match (left, right) with
    | (Z, S Z) -> LSucc Z
    | (Z, _) | (_, Z) -> failwith "unexpected behavior"
    | (S _, S _) as p ->
        let (n1, n3) = p in
        if S n1 = n3 then LSucc n1
        else
          let nextl = LSucc n1
          and nextr = gen_lttree (S n1) n3
          in LTrans ((n1, n3), (nextl, nextr))

  let prop_to_derivetree: prop -> derive_tree = function
    | Eq (left, right) -> gen_eqtree left right
    | LessThan (left, right) -> (
        match NatCalc.minus right left with
        | None | Some Z ->
            failwith @@ sprintf "%s is not less than %s" (string_of_nat left) (string_of_nat right)
        | Some (S Z) -> LSucc left
        | Some _ -> gen_lttree left right
      )

  let derivetree_printer: derive_tree -> string = fun derivetree ->
    let rec printer derivetree indent =
      match derivetree with
      | PZero n ->
        let res = string_of_nat n
        in indent ^ sprintf "Z plus %s is %s by P-Zero {}" res res
      | PSucc ((n, m, o), subtree) ->
        let son = string_of_nat in
        let (a, b, c) = (son n, son m, son o) in
        let node = sprintf "%s plus %s is %s by P-Succ" a b c
        and subtreestr = printer subtree (indent ^ "  ") in
        paren indent node subtreestr
      | TZero n ->
        let res = string_of_nat n
        in indent ^ sprintf "Z times %s is Z by T-Zero {}" res
      | TSucc ((n, m, o), (subL, subR)) ->
        let son = string_of_nat in
        let (a, b, c) = (son n, son m, son o) in
        let node = sprintf "%s times %s is %s by T-Succ" a b c
        and subLstr = printer subL (indent ^ "  ")
        and subRstr = printer subR (indent ^ "  ") in
        paren indent node @@ sprintf "%s;\n%s%s" subLstr indent subRstr
      | LSucc n ->
        let res = string_of_nat n
        in indent ^ sprintf "%s is less than S(%s) by L-Succ {}" res res
      | LTrans((a, b), (subL, subR)) ->
        let son = string_of_nat in
        let (n1, n3) = (son a, son b) in
        let node = sprintf "%s is less than %s by L-Trans" n1 n3
        and subLstr = printer subL (indent ^ "  ")
        and subRstr = printer subR (indent ^ "  ") in
        paren indent node @@ sprintf "%s;\n%s%s" subLstr indent subRstr
    in printer derivetree ""
end



let generator1: prop -> unit = fun prop ->
  prop
  |> CompNat1.prop_to_derivetree
  |> CompNat1.derivetree_printer
  |> print_endline

let exp_interpreter: exp -> nat = exp_run
let prop_interpreter: prop -> bool = function
  | Eq (l, r) -> exp_run l = r
  | LessThan (l, r) -> l < r

let exp_printer: exp -> string = string_of_exp
let prop_printer: prop -> string = function
  | Eq (l, r) ->
      sprintf "%s is %s" (string_of_exp l) (string_of_nat r)
  | LessThan (l, r) ->
      sprintf "%s is less than %s" (string_of_nat l) (string_of_nat r)
