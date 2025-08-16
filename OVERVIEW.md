# Overview of the source code 

```sh 
.
├── bin
│   ├── dune
│   └── main.ml
└── lib
    ├── ast.ml
    ├── ast.mli
    ├── dune
    ├── error.ml
    ├── error.mli
    ├── eval.ml
    ├── eval.mli
    ├── lexer.ml
    ├── lexer.mli
    ├── main.ml
    ├── parser.ml
    ├── parser.mli
    ├── table.ml
    └── table.mli
```

- [bin/main.ml](bin/main.ml): contain the executable of our project.

- [lib](lib): 
    - error.ml/mli: contain the error logic (custom error type, render function for pp).
    - lexer.ml/mli: contain all the lexer code for ou proposition. 
    - ast.ml/mli: contain the ast logic that our parser will build.
    - parser.ml.mli: contain our parser (for this project I settled on a classic, simple Pratt parser). 
    - eval.ml/mli: contain the code that take an ast and evaluate our proposition for given valuations.
    - table.ml/mli: contain the function that pp the truth table of ou proposition. 
    - main.ml: contain the main code so that the main function in build is just a call to this funciton (simpler module gestion). 

