#!/bin/bash

# Script za preimenovanje ikona iz appicon.co u iOS nazive
# Korak 1: Raspakuj ZIP fajl sa appicon.co
# Korak 2: PROMENI PUTANJU ISPOD na folder gde si raspakovala ikone
# Korak 3: Pokreni ovaj script

# ⚠️ PROMENI OVO SA PRAVOM PUTANJOM DO FOLDER-A SA IKONAMA!
ICONS_FOLDER="$HOME/Desktop/AppIcon.appiconset"  # PROMENI OVO!

# Proveri da li folder postoji
if [ ! -d "$ICONS_FOLDER" ]; then
    echo "❌ Folder ne postoji: $ICONS_FOLDER"
    echo "📋 Prvo raspakuj ZIP fajl sa appicon.co"
    echo "📋 Zatim promeni putanju u script-u (ICONS_FOLDER varijabla)"
    exit 1
fi

# Idi u folder sa ikonama
cd "$ICONS_FOLDER"

echo "🔄 Preimenovanje ikona..."

# Preimenuj fajlove po mapiranju
# 1024x1024
[ -f "icon-1024.png" ] && mv icon-1024.png Icon-App-1024x1024@1x.png && echo "✅ icon-1024.png → Icon-App-1024x1024@1x.png"

# 180x180 (60x60@3x)
[ -f "icon-180.png" ] && mv icon-180.png Icon-App-60x60@3x.png && echo "✅ icon-180.png → Icon-App-60x60@3x.png"

# 120x120 (60x60@2x)
[ -f "icon-120.png" ] && mv icon-120.png Icon-App-60x60@2x.png && echo "✅ icon-120.png → Icon-App-60x60@2x.png"

# 87x87 (29x29@3x)
[ -f "icon-87.png" ] && mv icon-87.png Icon-App-29x29@3x.png && echo "✅ icon-87.png → Icon-App-29x29@3x.png"

# 80x80 (40x40@2x)
[ -f "icon-80.png" ] && mv icon-80.png Icon-App-40x40@2x.png && echo "✅ icon-80.png → Icon-App-40x40@2x.png"

# 76x76 (76x76@1x - iPad)
[ -f "icon-76.png" ] && mv icon-76.png Icon-App-76x76@1x.png && echo "✅ icon-76.png → Icon-App-76x76@1x.png"

# 60x60 (40x40@3x) - PRVO preimenuj
[ -f "icon-60.png" ] && mv icon-60.png Icon-App-40x40@3x.png && echo "✅ icon-60.png → Icon-App-40x40@3x.png"

# 60x60 se koristi i za 20x20@3x - kopiraj
[ -f "Icon-App-40x40@3x.png" ] && cp Icon-App-40x40@3x.png Icon-App-20x20@3x.png && echo "✅ Kopiran Icon-App-40x40@3x.png → Icon-App-20x20@3x.png"

# 58x58 (29x29@2x)
[ -f "icon-58.png" ] && mv icon-58.png Icon-App-29x29@2x.png && echo "✅ icon-58.png → Icon-App-29x29@2x.png"

# 40x40 (40x40@1x) - PRVO preimenuj
[ -f "icon-40.png" ] && mv icon-40.png Icon-App-40x40@1x.png && echo "✅ icon-40.png → Icon-App-40x40@1x.png"

# 40x40 se koristi i za 20x20@2x - kopiraj
[ -f "Icon-App-40x40@1x.png" ] && cp Icon-App-40x40@1x.png Icon-App-20x20@2x.png && echo "✅ Kopiran Icon-App-40x40@1x.png → Icon-App-20x20@2x.png"

# 29x29 (29x29@1x)
[ -f "icon-29.png" ] && mv icon-29.png Icon-App-29x29@1x.png && echo "✅ icon-29.png → Icon-App-29x29@1x.png"

# 20x20 (20x20@1x)
[ -f "icon-20.png" ] && mv icon-20.png Icon-App-20x20@1x.png && echo "✅ icon-20.png → Icon-App-20x20@1x.png"

# 167x167 (83.5x83.5@2x - iPad Pro)
[ -f "icon-167.png" ] && mv icon-167.png Icon-App-83.5x83.5@2x.png && echo "✅ icon-167.png → Icon-App-83.5x83.5@2x.png"

# 152x152 (76x76@2x - iPad)
[ -f "icon-152.png" ] && mv icon-152.png Icon-App-76x76@2x.png && echo "✅ icon-152.png → Icon-App-76x76@2x.png"

echo ""
echo "📋 Preimenovane ikone:"
ls -lh Icon-App-*.png 2>/dev/null

echo ""
echo "🔄 Kopiranje u AppIcon folder projekta..."

# Kopiraj sve u AppIcon folder projekta
APP_ICON_FOLDER="$HOME/Documents/myChatEra/ZaMariju/ios/Runner/Assets.xcassets/AppIcon.appiconset"

if [ ! -d "$APP_ICON_FOLDER" ]; then
    echo "❌ AppIcon folder ne postoji: $APP_ICON_FOLDER"
    exit 1
fi

# Backup postojećih ikona (opciono)
echo "💾 Backup postojećih ikona..."
mkdir -p "$HOME/Desktop/icon-backup-$(date +%Y%m%d-%H%M%S)"
cp "$APP_ICON_FOLDER"/*.png "$HOME/Desktop/icon-backup-$(date +%Y%m%d-%H%M%S)/" 2>/dev/null

# Kopiraj nove ikone
cp Icon-App-*.png "$APP_ICON_FOLDER/"

echo "✅ Ikone su kopirane u: $APP_ICON_FOLDER"
echo ""
echo "📋 Finalna provera:"
ls -lh "$APP_ICON_FOLDER"/Icon-App-*.png | wc -l
echo "fajlova kopirano"

echo ""
echo "🎉 Gotovo! Sada možeš da build-uješ aplikaciju!"


