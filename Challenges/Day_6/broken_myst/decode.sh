#!/usr/bin/env bash
set -euo pipefail

# decode.sh
# ----------------
# Usage:
#   1) If metadata exists (encoded.meta): ./decode.sh <encoded_file>
#      It will read encoded_file.meta to learn how many rounds to reverse,
#      then write decoded output to <encoded_file>.decoded
#
#   2) If no metadata exists, it will brute-force rounds=1..10 and write
#      outputs to <encoded_file>.decoded.1, <encoded_file>.decoded.2, ...
#
# Note: The encoder used rotation + reversal so the operations applied here
#       are the same operations (they are self-inverse): rev and ROT13.

if [ $# -ne 1 ]; then
    echo "Usage: $0 <encoded_file>"
    exit 1
fi

encoded_file="$1"
meta_file="${encoded_file}.meta"

if [ ! -f "$encoded_file" ]; then
    echo "Error: file '$encoded_file' not found." >&2
    exit 1
fi

# helper to perform N rounds of (rev -> ROT13)
do_rounds() {
    local in_file="$1"
    local rounds="$2"
    local out_file="$3"

    local tmp1
    tmp1="$(mktemp)"
    trap 'rm -f "$tmp1"' RETURN

    cp -- "$in_file" "$tmp1"

    for (( i=0; i<rounds; i++ )); do
        # reverse then ROT13
        rev "$tmp1" > "${tmp1}.r"
        tr 'A-Za-z' 'N-ZA-Mn-za-m' < "${tmp1}.r" > "$tmp1"
        rm -f "${tmp1}.r"
    done

    mv -f "$tmp1" "$out_file"
    trap - RETURN
}

if [ -f "$meta_file" ]; then
    rounds="$(< "$meta_file")"
    # validate rounds is integer between 1 and 10
    if ! [[ "$rounds" =~ ^[0-9]+$ ]] || [ "$rounds" -lt 1 ] || [ "$rounds" -gt 1000 ]; then
        echo "Warning: meta file contains unexpected value '$rounds'. Aborting." >&2
        exit 1
    fi

    decoded_out="${encoded_file}.decoded"
    do_rounds "$encoded_file" "$rounds" "$decoded_out"
    echo "Decoded using metadata (rounds=$rounds) -> $decoded_out"
    exit 0
else
    echo "No metadata found; brute-forcing rounds 1..10..."
    for rounds in {1..10}; do
        decoded_out="${encoded_file}.decoded.${rounds}"
        do_rounds "$encoded_file" "$rounds" "$decoded_out"
        echo "Attempt (rounds=$rounds) -> $decoded_out"
    done
    echo "Brute-force attempts complete. Inspect the outputs to find the correct original."
    exit 0
fi
