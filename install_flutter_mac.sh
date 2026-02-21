#!/bin/bash
# Instalacija Flutter + PATH + CocoaPods (bez sudo za pod ako može)

set -e
FLUTTER_DIR="$HOME/development/flutter"
ZSHRC="$HOME/.zshrc"

echo "📁 Flutter će biti u: $FLUTTER_DIR"
mkdir -p "$(dirname "$FLUTTER_DIR")"

if [ -d "$FLUTTER_DIR/.git" ]; then
  echo "🔄 Flutter već postoji, ažuriram (git pull)..."
  cd "$FLUTTER_DIR" && git fetch && git checkout stable && git pull --ff-only && cd -
else
  echo "⬇️ Kloniram Flutter (stable)..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_DIR"
fi

# Dodaj u PATH u .zshrc ako već nije
LINE='export PATH="$PATH:'"$FLUTTER_DIR"'/bin"'
if ! grep -q "flutter/bin" "$ZSHRC" 2>/dev/null; then
  echo "" >> "$ZSHRC"
  echo "# Flutter" >> "$ZSHRC"
  echo "$LINE" >> "$ZSHRC"
  echo "✅ Dodato u $ZSHRC"
else
  echo "✅ Flutter PATH već postoji u .zshrc"
fi

# Odmah za ovu sesiju
export PATH="$PATH:$FLUTTER_DIR/bin"

echo "🔧 Prvo pokretanje Flutter (preuzimanje Dart SDK itd.)..."
"$FLUTTER_DIR/bin/flutter" --version

echo ""
echo "📱 CocoaPods (potrebno za iOS)..."
if command -v pod &>/dev/null; then
  echo "✅ pod već postoji: $(which pod)"
else
  if gem install cocoapods --user-install 2>/dev/null; then
    echo "✅ CocoaPods instaliran (user)"
    export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
    echo 'export PATH="$PATH:$(ruby -e '"'"'puts Gem.user_dir'"'"')/bin"' >> "$ZSHRC"
  else
    echo "⚠️ Pokreni ručno (traži lozinku): sudo gem install cocoapods"
  fi
fi

echo ""
echo "✅ Flutter je instaliran."
echo "   U novom Terminalu ukucaj: source ~/.zshrc   pa zatim: flutter doctor"
echo "   Ili zatvori i otvori novi Terminal, pa: flutter doctor"
echo ""
