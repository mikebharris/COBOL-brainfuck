# COBOL-Brainfuck
A interpreter for the Brainfuck language written in GnuCOBOL

Compile with
```cobc -x -free brainfuck.cbl```

Run with
```./brainfuck hello.bf```

## Known issues and things to improve

1. It is pretty darn slow
1. The program mandelbrot.bf doesn't run correctly 
1. The program primes.bf doesn't run correctly
1. Input (,) only takes a single character at a time and stores a single byte
1. Reimplement using POINTERs
1. Reimplement using speed-ups on looped blocks
