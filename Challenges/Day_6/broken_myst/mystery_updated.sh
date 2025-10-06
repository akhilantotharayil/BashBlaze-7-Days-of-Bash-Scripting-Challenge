#!/usr/bin/env bash
set -euo pipefail

# mystery.sh
# ----------------
# Usage: ./mystery.sh <input_file> <output_file>
#
# This script:
#  1. Applies ROT13 to the input file
#  2. Reverses the ROT13 output
#  3. Repeats (reverse -> ROT13) a random number of times between 1 and 10
#  4. Writes the final result to <output_file>
#  5. Writes the number of random iterations to <output_file>.meta
#
# The metadata (.meta) file lets a decoder know exactly how many iterations
# were used so the output can be decoded deterministically.

if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

input_file="$1"
output_file="$2"
meta_file="${output_file}.meta"

if [ ! -f "$input_file" ]; then
    echo "Error: input file '$input_file' not found." >&2
    exit 1
fi

# Create safe temporary files
tmp_rev="$(mktemp)"
tmp_work="$(mktemp)"
# Ensure cleanup on exit
cleanup() {
    rm -f -- "$tmp_rev" "$tmp_work"
}
trap cleanup EXIT

# Step 1: Apply ROT13 to the input and write to tmp_work
# Note: tr 'A-Za-z' 'N-ZA-Mn-za-m' performs ROT13
tr 'A-Za-z' 'N-ZA-Mn-za-m' < "$input_file" > "$tmp_work"

# Step 2: Reverse the ROT13 output into tmp_rev
rev "$tmp_work" > "$tmp_rev"

# Pick a random number between 1 and 10 (inclusive)
random_number=$(( ( RANDOM % 10 ) + 1 ))

# Save the random number to meta file so decoding is deterministic
echo "$random_number" > "$meta_file"

# Repeat the reverse + ROT13 sequence random_number times
for (( i=0; i<random_number; i++ )); do
    # reverse current content then ROT13 the reversed text
    rev "$tmp_rev" > "$tmp_work"
    tr 'A-Za-z' 'N-ZA-Mn-za-m' < "$tmp_work" > "$tmp_rev"
done

# Move final result to the desired output file (overwrite if exists)
mv -f "$tmp_rev" "$output_file"

# cleanup will run via trap
echo "Encoded '$input_file' -> '$output_file' (rounds: $random_number)"
echo "Metadata written to '$meta_file'"
