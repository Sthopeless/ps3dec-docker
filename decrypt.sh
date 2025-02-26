#!/bin/bash

ps3go="ps3dec d key"
folder_out="./out"
folder_dkeys="./keys"
folder_dkeys_out="./keys/dkeys_out"

gameTitle=$1
gameTarget=${gameTitle%.iso}

# Check if the .dkey file exists in the keys folder
if [ ! -f "$folder_dkeys/$gameTarget.dkey" ]; then
  echo "Error: $folder_dkeys/$gameTarget.dkey file not found!"
  exit 1
fi

# Read the key from the .dkey file and trim any whitespace
readkey=$(cat "$folder_dkeys/$gameTarget.dkey" | tr -d '[:space:]')

# Debugging information
echo "Game Target: $gameTarget"
echo "Read Key: $readkey"

# Execute the ps3go command
$ps3go "$readkey" "$gameTitle" "$folder_out/$gameTarget"
