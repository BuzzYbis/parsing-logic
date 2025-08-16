# Parsing logic 

## What is this project 

This project goal is to parse some logic proposition and return is truth table. 

## Build
```sh
dune build
```

## Run
```sh
dune exec -- truth_table "(p -> q) & (!r | q)"

dune exec -- truth_table  # then type an expression interactively
```

For the first type of execution, directly passing the proposition as an arg, you will may have to type `(p -> q) & (\!r | q)` to avoid your terminal to use `!` as a shortcut. If you do not want to be bothered by that, use the interactive mode.

## Grammar 

The grammar of the logic proposition we want to parse is fairly simple, we have: 
- Variable: 
- Constants: `true` | `false` 
- Prefix functions: 
    - Not: `!` 
- Infix functions: 
    - And: `&`
    - Or: `|`
    - Implies: `->` (right associative)
    - If and only if: `<=>` (right associative)
- Parenthesis: `(` | `)`

Precedence (high → low): `NOT` > `AND` > `OR` > `IMPLIES` > `IFF`.

## Overview 

See [OVERVIEW.md](OVERVIEW.md)
