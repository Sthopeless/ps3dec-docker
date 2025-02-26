#!/bin/bash

gameZip="$1"
purge7z="no"

# Check if a file was provided
if [ -z "$gameZip" ]; then
  echo "Error: No game zip file provided!"
  exit 1
fi

# Check if the provided file exists and is a ZIP file
if [[ ! -f "$gameZip" || "${gameZip##*.}" != "zip" ]]; then
  echo "Error: Provided file does not exist or is not a ZIP file!"
  exit 1
fi

# Check if 7z is installed
if ! command -v 7z &> /dev/null
then
    echo "7z is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y p7zip-full
fi

# Extract the zip file
outputDir="${gameZip%.zip}"
echo "Extracting '$gameZip' to '$outputDir'..."
mkdir -p "./$outputDir"

# Extract the file using 7z
7z x "$gameZip" -o"$outputDir"

# Remove 7z if required
if [ "$purge7z" == "yes" ]; then
  echo "Removing 7z..."
  sudo apt-get remove --purge -y p7zip-full
fi

exit 0
