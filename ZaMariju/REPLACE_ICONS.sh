#!/bin/bash

# Script za zamenu ikona aplikacije
# Korak 1: Raspakuj ZIP fajl sa appicon.co
# Korak 2: Pokreni ovaj script

# Prilagodi putanju do folder-a gde si raspakovala ikone
ICONS_SOURCE="/path/to/AppIcon.appiconset"  # PROMENI OVO!

# Putanja do AppIcon folder-a u projektu
ICONS_DEST="$HOME/Documents/myChatEra/ZaMariju/ios/Runner/Assets.xcassets/AppIcon.appiconset"

echo "🔄 Kopiranje ikona..."

# Kopiraj sve PNG fajlove
cp "$ICONS_SOURCE"/*.png "$ICONS_DEST/"

echo "✅ Ikone su zamenjene!"
echo "📋 Proveri da li su sve ikone kopirane:"
ls -lh "$ICONS_DEST"/*.png


