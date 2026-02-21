#!/bin/bash
# Pokreni u Terminalu: ./build_ipa.sh
# Flutter je u ~/development/flutter (ako nisi dodala u PATH, skripta koristi punu putanju).

set -e
cd "$(dirname "$0")"

FLUTTER="${FLUTTER:-$HOME/development/flutter/bin/flutter}"
if [ ! -x "$FLUTTER" ]; then
  FLUTTER="flutter"
fi

echo "📁 $(pwd)"
echo "🧹 flutter clean..."
"$FLUTTER" clean
echo "📦 flutter pub get..."
"$FLUTTER" pub get
echo "📥 flutter precache --ios (preuzima iOS engine ako nedostaje)..."
"$FLUTTER" precache --ios
echo "📱 pod install..."
(cd ios && pod install) || { echo "❌ 'pod' nije nađen. Jednom u Terminalu ukucaj: brew install cocoapods"; exit 1; }
echo "🏗️ flutter build ipa..."
"$FLUTTER" build ipa --export-options-plist ios/ExportOptions.plist

echo ""
echo "✅ Gotovo! IPA je ovde:"
echo "   $(pwd)/build/ios/ipa/Runner.ipa"
echo ""
