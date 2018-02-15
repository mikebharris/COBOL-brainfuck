# ++++++++++[>+++++++>+++++++>++++++++++>+++>+<<<<<-]>>++.>+.+++++++..+++.>++.<<-----.<+++++++++.>-.<.---.>>>.+.>.
A interpreter for the [brainfuck language](https://esolangs.org/wiki/Brainfuck) written in [GnuCOBOL](https://sourceforge.net/projects/open-cobol/).  Probably history's most verbose programming language used to run programs in one of history's most minimalistic languages.

Compile with
```cobc -x -free brainfuck.cbl```

Run with
```./brainfuck hello.bf```

## Example

```
$ cd programs
$ cobc -x -free ../brainfuck.cbl
$ ./brainfuck hello.bf 
Program loaded - length is 00837 bytes
Hello COBOL !
$
```

## Known issues and things to improve

1. It is pretty darn slow
1. The program mandelbrot.bf doesn't run correctly 
1. The program primes.bf doesn't run correctly
1. Input (,) only takes a single character at a time and stores a single byte
1. Reimplement using POINTERs
1. Reimplement using speed-ups on looped blocks
