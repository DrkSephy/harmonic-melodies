#!/bin/bash

# Just invoke ghc with some options.  Store intermediate build files
# somewhere in /tmp/
tmpdir="/tmp/.tmp-ghc-build"
mkdir -p $tmpdir
ghc --make -threaded -outputdir $tmpdir "$@"

# NOTE: the -threaded argument is needed for Euterpea.
