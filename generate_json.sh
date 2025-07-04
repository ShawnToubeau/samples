#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/ShawnToubeau/samples/master/"
OUTPUT_FILE="strudel.json"

# Start writing to output file
{
  echo '{'
  echo "  \"_base\": \"$BASE_URL\","

  first=1

  for dir in */; do
    key="${dir%/}"
    files=()
    while IFS= read -r -d '' file; do
      files+=("$file")
    done < <(find "$dir" -maxdepth 1 -type f -iname "*.wav" -print0 | sort -z)

    if [[ ${#files[@]} -gt 0 ]]; then
      [[ $first -eq 0 ]] && echo ","
      first=0
      echo "  \"$key\": ["
      for i in "${!files[@]}"; do
        echo -n "    \"${files[$i]}\""
        [[ $i -lt $((${#files[@]} - 1)) ]] && echo "," || echo
      done
      echo -n "  ]"
    fi
  done

  echo
  echo '}'
} > "$OUTPUT_FILE"
