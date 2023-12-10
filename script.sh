#!/bin/bash

display_help() {
  echo "Usage: $0 [options] directory"
  echo "Options:"
  echo "  -c, --compress <algorithm>  Compression algorithm to use (none, gzip, bzip, etc)"
  echo "  -o, --output <filename>    Output file name"
  echo "  -h, --help                 Display this help message"
}

while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -c|--compress)
      compress="$2"
      shift
      shift
      ;;
    -o|--output)
      output="$2"
      shift
      shift
      ;;
    -d|--directory)
      directory="$2"
      shift
      shift
      ;;
    -h|--help)
      display_help
      exit 0
      ;;
    *)
    
      echo "Unknown option"
      display_help
      exit 0
      ;;
  esac
done

if [[ ! -d $directory ]]; then
  echo "Error: Directory '$directory' does not exist"
  exit 1
fi

if [[ -z $compress ]]; then
  echo "Error: Compression algorithm is required"
  display_help
  exit 1
fi

if [[ -z $output ]]; then
  echo "Error: Output file name is required"
  display_help
  exit 1
fi

tar cf - "$directory" | $compress > "$output"

openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -in "$output" -out "$output.enc"

exec 1>/dev/null

exec 2>error.log


