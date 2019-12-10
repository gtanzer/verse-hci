#! /bin/bash
set -e

BIN_DIR=$(realpath "$(dirname "$0")")

if [ "$#" -ne 1 ]; then
    REL_FILE="$BIN_DIR/corpus.txt"
    echo "using default corpus location: $REL_FILE"
else REL_FILE=$1
fi

ABS_FILE=$(realpath "$REL_FILE")

(
    # Keep everything local to the script's directory
    # since the ocaml2prose program uses paths that are relative
    # to the present working directory, not to its script location
    cd "$BIN_DIR"
    make clean
    make
    mkdir -p output/synthesis/grammar
    "$BIN_DIR/main.native" "$ABS_FILE"
    (
        cd output
        dotnet build
        dotnet run
    )
)