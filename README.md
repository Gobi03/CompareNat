# CompareNat
『[プログラミング言語の基礎概念](https://www.fos.kuis.kyoto-u.ac.jp/~igarashi/CoPL/)』の演習システム用の導出木生成DSL

## ビルド
```
$ cd ./CompareNat/src
$ make
```

## 使い方
初めに以下を実行.
```
~/CompareNat/src$ ocaml compareNat.cma
# open CompareNat;;
```

### 使用例
#### ex) 命題 `S (S Z) plus Z is S (S Z)` の導出木
```
# let _ = generator1 @@ Eq (Plus(S (S Z), Z), S (S Z));;
S(S(Z)) plus Z is S(S(Z)) by P-Succ {
  S(Z) plus Z is S(Z) by P-Succ {
    Z plus Z is Z by P-Zero {}
  }
}
- : unit = ()
```

#### ex) 命題:  `S Z times S Z is S Z`
```
# let _ = generator1 @@ Eq (Times(S Z, S Z), S Z);;
S(Z) times S(Z) is S(Z) by T-Succ {
  Z times S(Z) is Z by P-Zero {};
  S(Z) plus Z is S(Z) by P-Succ {
    Z plus Z is Z by P-Zero {}
  }
}
- : unit = ()
```

#### ex) 命題:  `S(S Z) is less than S(S(S Z))`
generator1 ~ 3 がそれぞれ推論規則 CompareNat1 ~ 3 に基づく導出木を生成する.

```
let _ = generator1 @@ LessThan (S(S Z), S(S(S(S(S Z)))));;
S(S(Z)) is less than S(S(S(S(S(Z))))) by L-Trans {
  S(S(Z)) is less than S(S(S(Z))) by L-Succ {};
  S(S(S(Z))) is less than S(S(S(S(S(Z))))) by L-Trans {
    S(S(S(Z))) is less than S(S(S(S(Z)))) by L-Succ {};
      S(S(S(S(Z)))) is less than S(S(S(S(S(Z))))) by L-Succ {}
  }
}
- : unit = ()
```

```
let _ = generator2 @@ LessThan (S(S Z), S(S(S(S(S Z)))));;
S(S(Z)) is less than S(S(S(S(S(Z))))) by L-SuccSucc {
  S(Z) is less than S(S(S(S(Z)))) by L-SuccSucc {
    Z is less than S(S(S(Z))) by L-Zero {}
  }
}
- : unit = ()
```


#### インタプリタとプリティプリンタ
```
# let _ = exp_interpreter @@ Plus(S (S Z), Z);;
- : nat = S (S Z)
# let _ = prop_printer @@ Eq (Times(S Z, S Z), S Z);;
- : string = "S(Z) times S(Z) is S(Z)"
```
