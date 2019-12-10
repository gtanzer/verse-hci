# VERSE

VERSE is a framework for building program synthesizer that can quickly produce programs given a small set of input/output examples. Instead of iterating over the space of all potential program permutations, it uses concepts analogous to back propagation and auto differentiation in machine learning. Using these techniques, VERSE lets you define a program synthesizer by providing it with examples of the programs you want to have synthesized. A single example program is sometimes enough for it.

## General Purpose Language

VERSE programs are written in a simple functional language based around composing operators. VERSE programs support a simple type system of `string`, `int`, `bool`. These programs have access to inputs and outputs, which are defined in the corpus metadata.

### Corpus Metadata

A VERSE corpus should define available inputs and specify output types. This can be done using the `@input` and `@output` annotations (documented below) at the top of a corpus file.

#### `@input $TYPE $ID`

`$TYPE` can be: `string`, `int`, or `bool`.
`$ID` can be any alphabetical identifier, such as `x`.

**Example:** `@input string x` informs VERSE that your programs will be operating on a string input which will be referred to as `x`. This value can be used in the example programs you provide.

#### `@output $TYPE`

`$TYPE` can be: `string`, `int`, or `bool`.

**Example:** `@output string` informs VERSE that your programs will return a `string` result.

### Functional Language

VERSE programs are functional and do not support control flow operations like `if` or `for`. All operators are pure functions which may take n-arguments and return one result.

An example program may be: `append(x, x)`, which would duplicate the string input.

## Standard Library

VERSE program may draw on a standard library of pure functions that can be used as operators. These are listed below, loosely grouped on their purpose:

### Arithmetic

#### `add(a: int, b: int) -> int`

Returns the int result of `a + b`.

#### `mod(a: int, b: int) -> int`

Returns the int result of `a % b`.

#### `mult(a: int, b: int) -> int`

Returns the int result of `a * b`.

#### `neg(a: int) -> int`

Returns the int result of `-1 * a`.

### String

#### `append(s1: string, s2: string) -> string`

Returns the string resulting from concatenating `s1` and `s2`.

#### `lowercase(s: string) -> string`

The lower case version of a string `s`.

#### `regpos(s: string, r: string) -> string`

Returns the first position that the regex `r` occurs at in the given string `s`.

#### `replace(s: string, f: string, r: string) -> string`

Replace all occurences of a substring `f` in a string `s` with a replacement `r`.

#### `reverse(s: string) -> string`

Returns a string `s` with the characters in reverse order.

#### `substring(s: string, start: int, end: int) -> string`

Returns the characters from index `start` and up to but not including `end` for the given string `s`.

#### `uppercase(s: string) -> string`

The upper case version of a string `s`.

### Collections

#### `concat(l1: a'[], l2: a'[]) -> a'[]`

Returns the resulting list after concatenating the given lists `l1` and `l2`.

#### `drop(l: a'[], n: int) -> a'[]`

Returns all but the first `n` elements of the given list `l`.

#### `join(l: string[], d: string) -> string`

Returns a string made by inserting the delimiter `d` between each element in `l` and concatenating all the elements into a single string.

#### `kth(l: a'[], n: int) -> a'`

Returns the `n`th element of the given list `l`. If `n` is negative the element at `l` length + `n` is returned.

#### `length(l: a'[]) -> int`

Returns the length of the list `l`.

#### `split(s: string, d: string) -> string[]`

Splits a string `s` into an array of strings based on the given delimiter `d`.

#### `stride(l: a'[], n: int) -> a'[]`

Returns a list composed of every `n`th element in the given list `l`.

#### `take(l: a'[], n: int) -> a'[]`

Returns the first `n` elements of the given list `l`.