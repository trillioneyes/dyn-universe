# Fun with "Dynamic" Typing: An Introduction to Universes

This is a simple introduction to universes, a tool that can be used in dependently-
typed languages to get all the convenience of dynamic types (often referred to in
academia as "generic programming") from inside a strong static type system. My code
is written in Idris, but this guide is aimed at people who know Haskell or OCaml
but are new to dependent typing. (At least, I hope. If someone in the target audience
finds something unclear, feel free to submit an issue!)

## Using this tutorial
This tutorial contains a bunch of .md files. You can just read through them all if
you like... but they are also valid "literate" idris files! That means if you
download the raw files, you can run them directly
in the idris repl (everything that's not code will be treated as a comment). You
can use this to play with some of the examples, if you want.