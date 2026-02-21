#!/bin/bash
# Kopira provisioning profil u sistem folder

set -e
PROFILE="$HOME/Downloads/MyChatEraAI_DIstribution2.mobileprovision"
DEST="$HOME/Library/MobileDevice/Provisioning Profiles"

if [ ! -f "$PROFILE" ]; then
  echo "Fajl nije nađen: $PROFILE"
  echo "Proveri da li je u Downloads i kako se tačno zove (ls ~/Downloads/*.mobileprovision)"
  exit 1
fi

mkdir -p "$DEST"
cp "$PROFILE" "$DEST/"
echo "Kopirano. Lista:"
ls -la "$DEST"
