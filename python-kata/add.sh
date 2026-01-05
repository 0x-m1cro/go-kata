#!/bin/bash
name="${1}"
if [[ -z "${name}" ]]; then
  echo "please provide a 'kebab-case' name of the new challenge."
  exit 1
fi
number=$(find . -maxdepth 2 -type d -name '[0-9][0-9]-*' | wc -l)
number=$((10#$number + 1))
number=$(printf "%02d" $number)
folder="$number-${1}"
mkdir -p "$folder"
cp README_TEMPLATE.md "$folder/README.md"
echo "Created kata: $folder"
