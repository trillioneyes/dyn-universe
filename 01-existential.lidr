The idea behind our dynamic typing system is to pass around not just objects, but 
pairs containing an object and its type. Indeed, this is similar to what is done in
dynamically-typed languages such as lisp or python: every value is accompanied by
its type, which can be queried by the code that consumes the value.
In Idris we can do something similar!

```

> module Existential

> pair : (a : Type ** a)
> pair = (Int ** 3)

```

The syntax `(a : Type ** a)` describes a type containing dependent pairs. In general,
`(a : b ** c)` is similar to the type `(b, c)` in Haskell or `b * c` in OCaml, except
that `c` can refer to `a`. We took advantage of this in our type declaration for
`pair`: `(a : Type ** a)` is the type of pairs containing a value and its type!
We also supplied a value of type `(a : Type ** a)` using a confusingly similar syntax.

Anyway, now we know the type of our "dynamic values". Let's define an alias to save some
typing.

```

> Dyn : Type
> Dyn = (a : Type ** a)

```

Notice that we didn't need any special syntax to define our type alias -- this is
because in Idris, types are just values, so we can just use the standard declaration
and definition syntax!

Now that we have a single type that all of our dynamic values fit into... we can
put them into an ordinary list, without having to even define our own HList type
or something!

```

> hetList : List Dyn
> hetList = [pair, (Char ** 'a'), (String ** "hello, types!"),
>  	     (List Dyn ** [])]

```

Notice that we even put another heterogeneous list in there -- this really is a lisp-
style list, and we could represent trees with it if we wanted. This syntax is a bit
inconvenient though. We have to write the type of everything we put in our list! This
verbosity is what all the dynamic language fans are complaining about when they talk
about C. Let's see if we can make it a little nicer.

OCaml has a function called `Obj.magic` that can transform any value into a dynamic
value. Let's try the same thing here!

```

> magic : anything -> Dyn
> magic x = (_ ** x)

```

The `_` in our pair syntax means "I don't feel like writing this part out, but you,
the compiler, should be able to infer it from context. Please do so!" And indeed, it
works. Now we can define another heterogeneous list with (slightly) nicer syntax.

```

> another : List Dyn
> another = [magic Z, magic "strings again? Booooring",
>  	     magic False]

```

So we're done now, right? We have heterogeneous lists and all the dubious utility of
a dynamic typing system, right here in our static stronghold?

Well... not quite. For reasons both pragmatic and theoretical, in Idris you're not
allowed to pattern match on types. This means that the most important thing that makes
dynamic typing possible -- the ability for code to examine the type of a value -- is
not yet within our grasp.

Tune in next time, when we solve this problem by introducing universes!