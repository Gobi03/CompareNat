(*** example ***)
let _ = generator @@ Eq (Plus(Z, S (S Z)), S (S Z));;
let _ = generator @@ Eq (Plus(S (S Z), Z), S (S Z));;

let _ = generator @@ Eq (Times(S Z, S Z), S Z);;

let _ = exp_interpreter @@ Plus(S (S Z), Z);;
let _ = prop_printer @@ Eq (Times(S Z, S Z), S Z);;
