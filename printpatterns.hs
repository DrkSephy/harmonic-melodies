import Slonimsky
import Control.Monad
import Euterpea
import System.Console.GetOpt
import System.Environment

-- compile with ./build.sh printpatterns.hs

-- example usage:
-- echo '(C,4) 4 [-6,-2,2]' | ./printpatterns -n 24 -s
-- print C major scale:
-- echo '(C,4) 0 [2,2,1,2,2,2,1]' | ./printpatterns -n 8

-- for more on getOpt usage, look here:
-- http://hackage.haskell.org/package/base-4.8.1.0/docs/System-Console-GetOpt.html
data Opts = Opts {slnm :: Bool, nNotes :: Int} deriving (Show)
defaultOpts = Opts {slnm = False, nNotes = 12}

options :: [OptDescr (Opts -> Opts)]
options =
    [ Option ['s'] ["slonimsky"]
        (NoArg (\o -> o {slnm = True})) "output Slonimsky pattern"
    , Option ['n'] ["numnotes"]
        (ReqArg (\n o -> o {nNotes = read n :: Int}) "NUM")
          "number of notes to output"
    ]

-- XXX is RequireOrder reall the right thing?
parseOpts :: [String] -> IO ([Opts -> Opts], [String])
parseOpts args =
    case getOpt RequireOrder options args of
        (opts,leftover,[]) -> return (opts,leftover)
        (_,_,errs) -> fail (concat errs ++ usageInfo header options)
    where header = "Usage: printpatterns [options]"

-- XXX replace program name with $0 from environment
-- XXX actually, it would probably be more useful to have the pattern
-- type as well as the number of notes read from each line :\

processOpts :: [Opts -> Opts] -> Opts
processOpts opts = foldr ($) defaultOpts opts

-- XXX do this over and over.  shouldn't use forever $ do right (since
-- we would be calling getArgs over and over)?  can you just use interact?
main = do
    args <- getArgs
    (optList,leftover) <- parseOpts args
    let opts = processOpts optList
    line <- getLine
    let (p,i,l) = parsePattern line
    print $ take (nNotes opts) $ (patGen $ slnm opts) p i l
        where
            patGen True = slonimsky
            patGen False = (\a b c -> intervalScale a (toEnum b) c)

parsePattern :: String -> (Pitch, Int, [Int])
parsePattern s = (p,i,l)
    where (l,_) = head (reads k :: [([Int],String)])
          (i,k) = head (reads h :: [(Int,String)])
          (p,h) = head (reads s :: [(Pitch,String)])
