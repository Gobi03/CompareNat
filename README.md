# CompareNat
『[プログラミング言語の基礎概念](https://www.fos.kuis.kyoto-u.ac.jp/~igarashi/CoPL/)』の演習システム用の導出木生成DSL

## ビルド方法
```
$ cd ./CompareNat/src
$ make
```

## 使い方
初めに、REPL上で以下を実行して読み込む.
```
# #load "compareNat.cma";;
# open CompareNat;;
```

### 使用例
#### ex) 命題 `S (S Z) plus Z is S (S Z)` の導出木
```
# let _ = compile @@ Eq (Plus(S (S Z), Z), S (S Z));;
S(S(Z)) plus Z is S(S(Z)) by P-Succ {
  S(Z) plus Z is S(Z) by P-Succ {
    Z plus Z is Z by P-Zero {}
  }
}
- : unit = ()
```

#### ex) 命題:  `S Z times S Z is S Z`
```
# let _ = compile @@ Eq (Times(S Z, S Z), S Z);;
S(Z) times S(Z) is S(Z) by T-Succ {
  Z times S(Z) is Z by P-Zero {};
  S(Z) plus Z is S(Z) by P-Succ {
    Z plus Z is Z by P-Zero {}
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
