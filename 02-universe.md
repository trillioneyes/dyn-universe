> module Universe

In Idris, we can't pattern match on types. And for various reasons, we WANT this
restriction. So how do we get around it to make our dynamic type system usable?

Simple: we declare a universe.

There's nothing special about universes; they're just any type that is intended
to represent the type system in a form that we can examine. We can formalize this
notion with a type class:

```

> class Universe a where
>   interp : a -> Type

```

See? A universe is just a type whose elements can be converted into types. Let's
look at a concrete example (which happens to be the standard example used in all
the papers):

```

> data SmallUniverse = INT | LIST SmallUniverse | PAIR SmallUniverse SmallUniverse

> instance Universe SmallUniverse where
>   interp INT = Int
>   interp (LIST t) = List (interp t)
>   interp (PAIR t1 t2) = (interp t1, interp t2)

```

So if we have a value like `LIST (PAIR INT (LIST INT))`, we can `interp` it to get
the type `List (Int, List Int)`. Pretty straightforward. And now we have a representation
of types that we can inspect with our functions!

So let's move back to our heterogeneous list example, updating it to use universes
instead of raw types.

```

> Dyn : Universe u => Type -- we're parameterizing over the universe for now
> Dyn {u} = (t : u ** interp t)

```

This is new syntax, so let's go over it before we continue. `Universe u =>` is similar
to Haskell's typeclass constraints, but what's this `u`? It doesn't occur elsewhere
in the type of `Dyn`...

Well, what it actually does is introduce an implicit argument. This version of `Dyn` is
actually a function, taking `u` (the universe we're using to represent our types) as an
argument! We gain access to the argument by pattern matching on it with `{u}`. This just
means that we can use our `SmallUniverse` type for now, but later when we design a more
expressive universe type, we can switch to that one without redefining `Dyn`.

Anyway, let's get back to our list:

```

> uHetList : List (Dyn {u = SmallUniverse})
> uHetList = [(INT ** 5)
>  	     ,(PAIR INT INT ** (0, -9))
>	     ,(LIST (PAIR INT (LIST INT)) **
>	       [(1,[]), (2,[0,1,2])])
>	     ]

```

So far, we've only rederived the functionality we had before. In fact, we don't even
have all of it -- I don't think it's possible to define our old `magic` function anymore.
We have to write these ugly pseduo-types again and there's no way to get around it.

But... now we have things that we can pattern match on. And that means we can finally use
the "fun" things about dynamic types!

Let's start with a simple example: a function that returns the "size" of anything. For
non-containers, the size is 1; for pairs, the size is 2; and for lists, the size is the
length of the list.

```

> dynLength : Dyn {u = SmallUniverse} -> Int
> dynLength (LIST _ ** xs) = cast (length xs) -- length returns a Nat, not an Int
> dynLength (PAIR _ _ ** _) = 2
> dynLength (INT ** _) = 1

```

So now we can calculate the "length" of any value whose type is in our universe, as if
it was a sequence!

Stepping outside of our `Dyn` type for a moment, we can also do something like this:

```

> size : (t : SmallUniverse) -> interp t -> Int
> size (LIST t) xs = sum (map (size t) xs)
> size (PAIR t1 t2) (a,b) = size t1 a + size t2 b
> size INT _ = 1

```

This calculates the "deep" size of a value: the total number of "leaf" nodes, if you interpret
the value as a kind of tree. It doesn't work with our `Dyn` type though; instead, it
requires you to pass a universe value to the function. In my opinion, this style of
generic programming is nicer in the real world than `Dyn`, but since our goal is just
to build a dynamically typed pillow fort in the middle of Static Land, we'll be sticking
with `Dyn` for now.

Next time: `SmallUniverse` isn't very good. Let's create a larger one!