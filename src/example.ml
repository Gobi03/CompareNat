(* #load "compareNat.cma" *)
open CompareNat

(*** example ***)
(* Nat *)
let _ = generator1 @@ Eq (Plus(Z, S (S Z)), S (S Z));;
let _ = generator1 @@ Eq (Plus(S (S Z), Z), S (S Z));;

let _ = generator1 @@ Eq (Times(S Z, S Z), S Z);;

let _ = exp_interpreter @@ Plus(S (S Z), Z);;
let _ = prop_printer @@ Eq (Times(S Z, S Z), S Z);;

(* CompareNat *)
let _ = generator1 @@ LessThan (S (S Z), S (S (S Z)));;
let _ = generator2 @@ LessThan (S (S Z), S (S (S Z)));;
let _ = generator3 @@ LessThan (S (S Z), S (S (S Z)));;

let _ = generator1 @@ LessThan (S(S Z), S(S(S(S(S Z)))));;
let _ = generator2 @@ LessThan (S(S Z), S(S(S(S(S Z)))));;
let _ = generator3 @@ LessThan (S(S Z), S(S(S(S(S Z)))));;
