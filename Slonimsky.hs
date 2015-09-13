{- Simple functions for generating scales and melodic patterns.
 - Methods:
 - 1. take a list of intervals (which typically sums to 12), align it with
 -    the desired root, and transpose everything.  Modes are easily
 -    implemented in this method, simply by shifting the list of intervals.
 - 2. Slonimsky-style scales + patterns.  For many of his basic scales, there
 -    is a uniform interval sequence that is augmented with ultra/infra/inter-
 -    polations.
 -}

module Slonimsky
( majInt
, intervalScale
, slonimsky
, genSlonimsky
, playList
, playListDur
) where

import Euterpea

-- scales based on lists of intervals:
majInt :: [Int]
majInt = [2,2,1,2,2,2,1]
data MMode = Ionian | Dorian | Phrygian | Lydian | Mixolydian
                    | Aeolian | Locrian deriving(Enum,Show)

-- parameters are root, mode, interval list.
intervalScale :: Pitch -> MMode -> [Int] -> [Pitch]
intervalScale p m ints = map (\x -> trans x p) ps where
    ps = 0:(psums $ drop (fromEnum m) (cycle ints))


-- scales + melodic patterns from Slonimsky's thesaurus:

-- inputs: root (as a pitch); main interval; offset list
slonimsky :: Pitch -> Int -> [Int] -> [Pitch]
slonimsky p i os = map (\x -> trans x p) (genSlonimsky i os)

-- NOTE: If i is the basic interval, then we can classify the second
-- parameter as follows:
-- {infrapolations} < (-i) < {interpolations} < 0 < {ultrapolations}

-- {{{ Examples
-- The following would generate Slonimsky's first example (indexed 1),
-- which is a tritone progression with one interpolated note:
-- slonimsky (C,4) 6 [-5]
-- to play part of it (provided you have midi set up already) try:
-- playList $ take 10 $ slonimsky (C,4) 6 [-5]
-- (The "take 10" is needed since the slonimsky function produces an
-- infinite list.)
-- Example 193 (page 29) can be expressed as:
-- slonimsky (C,4) 4 [1,2]
-- Example 352 (page 47):
-- slonimsky (C,4) 4 [-6,-2,2]
-- NOTE: (Enharmonics.) Euterpea's trans function arbitrarily uses
-- sharps instead of flats, so the output of the slonimsky function
-- will only agree with the actual text *modulo enharmonics*.
-- }}}

-- the following produces an (infinite) list of absolute intervals
-- (in semitone units) from which lists of pitches can then easily
-- be constructed (via mapping trans).
genSlonimsky :: Int -> [Int] -> [Int]
genSlonimsky 0 _ = []
genSlonimsky i os =
    offsetMerge [0,i..] (difflist os)
        where
        offsetMerge :: [Int] -> [Int] -> [Int]
        offsetMerge [] _ = []
        offsetMerge (x:y:xs) os =
            x:(foldr (\k l@(h:hs) -> (k+h):l) (offsetMerge (y:xs) os) os)
        offsetMerge xs _ = xs -- for short lists, just give it back.

-- some utility functions: {{{

-- list of partial sums:
psums :: (Num a) => [a] -> [a]
psums l = ps_help 0 l
    where ps_help _ [] = []
          ps_help r (x:xs) = (r+x):(ps_help (r+x) xs)

-- difference list:
difflist :: (Num a) => [a] -> [a]
difflist l = zipWith (-) l ((drop 1 l) ++ [0])

-- convert pitch list to music (mainly for scales: each note will
-- be of the same duration)
musicFromPlist :: Dur -> [Pitch] -> Music Pitch
musicFromPlist d = foldl (\m p -> m :+: Prim (Note d p)) (rest 0)

dumpScale :: FilePath -> [Pitch] -> IO ()
dumpScale f ps = writeMidi f (musicFromPlist qn ps)

playListDur :: Dur -> [Pitch] -> IO ()
playListDur d = play . (musicFromPlist d)

playList = playListDur qn

-- XXX: the very first note seems longer than than the rest.
-- is the rest 0 the problem?

-- }}}
