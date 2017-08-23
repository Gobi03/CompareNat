open Printf

type nat = Z | S of nat

(* cast *)
let rec string_of_nat = function
  | Z -> "Z"
  | S n -> sprintf "S(%s)" @@ string_of_nat n

let rec int_of_nat = function
  | Z -> 0
  | S n -> 1 + int_of_nat n

let nat_of_int x =
  if x < 0 then failwith "not a Natural Number"
  else
    let rec func = function
      | 0 -> Z
      | n' -> S (func n')
    in func x

(* operators *)
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
