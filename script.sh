#!/bin/bash

# function to display help message
display_help() {
  echo "Usage: $0 [options] directory"
  echo "Options:"
  echo "  -c, --compress <algorithm>  Compression algorithm to use (none, gzip, bzip, etc)"
  echo "  -o, --output <filename>    Output file name"
  echo "  -h, --help                 Display this help message"
}

# parse command-line arguments
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -c|--compress)
      compress="$2"
      shift # past argument
      shift # past value
      ;;
    -o|--output)
      output="$2"
      shift # past argument
      shift # past value
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
      # unknown option
      echo "Unknown option"
      display_help
      exit 0
      ;;
  esac
done

# check if directory exists
if [[ ! -d $directory ]]; then
  echo "Error: Directory '$directory' does not exist"
  exit 1
fi

# check if compression algorithm is provided
if [[ -z $compress ]]; then
  echo "Error: Compression algorithm is required"
  display_help
  exit 1
fi

# check if output file name is provided
if [[ -z $output ]]; then
  echo "Error: Output file name is required"
  display_help
  exit 1
fi

# create backup archive
tar cf - "$directory" | $compress > "$output"

# encrypt backup archive
openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -in "$output" -out "$output.enc"

# redirect all output except errors to /dev/null
exec 1>/dev/null

# write errors to error.log file
exec 2>error.log

echo "Backup completed successfully"



