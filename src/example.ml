(* #load "compareNat.cma" *)
open CompareNat

(*** example ***)
let _ = generator1 @@ Eq (Plus(Z, S (S Z)), S (S Z));;
let _ = generator1 @@ Eq (Plus(S (S Z), Z), S (S Z));;

let _ = generator1 @@ Eq (Times(S Z, S Z), S Z);;

let _ = exp_interpreter @@ Plus(S (S Z), Z);;
let _ = prop_printer @@ Eq (Times(S Z, S Z), S Z);;

let _ = generator1 @@ LessThan (S (S Z), S (S (S Z)));;

