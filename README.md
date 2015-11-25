# harmonic-melodies

## What is this?

* A concise, programmatic description of Slonimsky's [*Thesaurus of Scales and Melodic Patterns*](http://www.u.arizona.edu/~gross/Slonimsky/Thesaurus.of.Scales.And.Melodic.Patterns.Nicolas.Slonimsky.pdf)
* Searches against Slonimsky's thesaurus
* More thesaurus-like functionality, across several axes of similarity (interval patterns, musical harmony...)


## Dependencies
* [ghc](https://www.haskell.org/ghc/)
* [Euterpea](https://github.com/Euterpea/Euterpea)
* A midi player

### Installing ghc

On *-nix, see your package manager.  For Mac, this may be useful: [ghc](http://ghcformacosx.github.io/).

### Installing Euterpea

You can do so with the following commands:

```
cabal update

cabal install Euterpea
```

### midi players

For Linux you can use [timidity++](http://timidity.sourceforge.net). For Mac you can use [SimpleSynth](http://notahat.com/simplesynth/). For more information look [here](https://github.com/Euterpea/Euterpea). 

## Getting Started

1. If you have **Linux** start your midi player:

  ```$ timidity -A90 -iA -Os &```

  You might also need to make sure the `snd_dummy` module isn't loaded:
  `# [[ lsmod | grep -q snd_dummy ]] && rmmod snd_dummy`
  
  If you have a **Mac** you will need to start your midi player.

2. Start ghci and load Slonimsky.hs:

  ```ghci> :load Slonimsky.hs```

3. Play something from the thesaurus:

  ```ghci> playList $ take 10 $ slonimsky (C,4) 4 [-7,-4,2]```

  Sound should happen.  If not, restart timidity and try again.
