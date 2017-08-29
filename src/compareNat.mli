(* syntax *)
type nat = Z | S of nat

type exp = Plus of nat * nat
         | Times of nat * nat

type prop = Eq of exp * nat
          | LessThan of nat * nat


(* processor *)
val exp_interpreter: exp -> nat
val exp_printer: exp -> string

val prop_interpreter: prop -> bool
val prop_printer: prop -> string

val generator1: prop -> unit
val generator2: prop -> unit
(* val generator3: prop -> unit *)

