#!/bin/bash

CONTAINER="github"  # github or dockerhub
VERSION="alpine"

githubContainer="ghcr.io/sthopeless/ps3dec-docker"
dockerhubContainer="sthopeless/ps3dec-docker"

ps3go="/usr/local/bin/ps3dec d key"
folder_out="./output"
folder_dkeys="./keys"

gameTitle="$1"
gameTarget="${gameTitle%.iso}"

lekey="$folder_dkeys/$gameTarget"

# Ensure a game title was provided
if [ -z "$gameTitle" ]; then
  echo "Error: No game title provided!"
  exit 1
fi

# Check if the .dkey file exists in the keys folder
if [ ! -f "$lekey.dkey" ]; then
  echo "Error: $lekey.dkey file not found!"
  
  # Check if a zip file exists in the keys folder
  if [ -f "$lekey.zip" ]; then
    echo "Found zip file: $lekey.zip"
    
    # Check if the zip file contains the .dkey file
    if unzip -l "$lekey.zip" | grep -q "$gameTarget.dkey"; then
      echo "Extracting $gameTarget.dkey from zip file..."
      unzip -j "$lekey.zip" "$gameTarget.dkey" -d "$folder_dkeys"
      rm -rf "$lekey.zip"
    else
      echo "Error: $gameTarget.dkey not found in zip file!"
      exit 1
    fi
  else
    echo "Error: $lekey.dkey file or zip file not found!"
    exit 1
  fi
fi

# Read the key from the .dkey file and trim any whitespace
readkey=$(tr -d '[:space:]' < "$lekey.dkey")

# Debugging information
echo "Game Target: $gameTarget"
echo "Read Key: $readkey"

# Create the output directory if it doesn't exist
mkdir -p "$folder_out"

# Run the appropriate container
if [ "$CONTAINER" == "github" ]; then
  docker run --rm -it --name ps3dec \
    -v "$(pwd):/app" \
    "$githubContainer:$VERSION" \
    $ps3go "$readkey" "$gameTitle" "$folder_out/$gameTitle"
  rm -rf "$gameTitle"
  rm -rf "$lekey"
elif [ "$CONTAINER" == "dockerhub" ]; then
  docker run --rm -it --name ps3dec \
    -v "$(pwd):/app" \
    "$dockerhubContainer:$VERSION" \
    $ps3go "$readkey" "$gameTitle" "$folder_out/$gameTitle"
  rm -rf "$gameTitle"
  rm -rf "$lekey"
else
  echo "Error: Invalid container choice!"
  exit 1
fi
