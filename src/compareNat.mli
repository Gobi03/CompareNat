(* syntax *)
type nat = Z | S of nat

type exp = Plus of nat * nat    (* _0 plus _1 *)
         | Times of nat * nat   (* _0 times _1 *)

type prop = Eq of exp * nat     (* _0 is _1 *)


(* processor *)
val exp_interpreter: exp -> nat
val exp_printer: exp -> string

val prop_interpreter: prop -> bool
val prop_printer: prop -> string

val generator: prop -> unit

