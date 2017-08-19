open Printf

(** ペアノ数 **)
type nat = Z | S of nat

let rec string_of_nat = function
  | Z -> "Z"
  | S n -> sprintf "S(%s)" @@ string_of_nat n
let rec int_of_nat = function
  | Z -> 0
  | S n -> 1 + int_of_nat n
let rec plus n m =
  match n with
  | Z -> m
  | S n' -> S (plus n' m)
let rec minus: nat -> nat -> nat option =
  fun n m ->                    (* n - m *)
    match (n, m) with
    | (Z, S _) -> None
    | (n', Z) -> Some n'
    | (S n', S m') -> minus n' m'
let times n m =
  let rec calc x res =
    match x with
    | Z -> res
    | S x' -> calc x' @@ plus m res
  in calc n Z


(*** DSL ***)
(* syntax *)
type exp = Plus of nat * nat    (* _1 plus _2 *)
         | Times of nat * nat   (* _1 times _2 *)
type prop = Eq of exp * nat     (* _1 is _2 *)


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


(* AST *)
type derive_tree = 
    PZero of nat                              (* Z plus _1 is _1 *)
  | PSucc of (nat * nat * nat) * derive_tree  (* (_1 plus _2 is _3) と部分木 *)
  | TZero of nat                              (* Z times n is Z *)
  | TSucc of (nat * nat * nat) * (derive_tree * derive_tree)  (* [_1 times _2 is ?; _2 plus ? is _3] と部分木の組 *)


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

let prop_to_derivetree: prop -> derive_tree = function
  | Eq (left, right) -> gen_eqtree left right

let paren: string -> string -> string -> string =
  fun indent node subtreestr ->
    sprintf "%s%s {\n%s\n%s}" indent node subtreestr indent

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
  in printer derivetree ""


let generator: prop -> unit = fun prop ->
  prop
  |> prop_to_derivetree
  |> derivetree_printer
  |> print_endline

let exp_interpreter: exp -> nat = exp_run
let prop_interpreter: prop -> bool = function
  | Eq (l, r) -> exp_run l = r

let exp_printer: exp -> string = string_of_exp
let prop_printer: prop -> string = function
  | Eq (l, r) -> sprintf "%s is %s" (string_of_exp l) (string_of_nat r)
