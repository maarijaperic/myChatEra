#!/bin/bash
# Skripta: nađe .cer, napravi cert.pem i MyChatEra.p12
# Radi u ~/Desktop/MyChatEra_Signing (ili u folderu gde je skripta)

set -e
SIGNING_DIR="${HOME}/Desktop/MyChatEra_Signing"
[ -d "$SIGNING_DIR" ] || SIGNING_DIR="$(dirname "$0")"
cd "$SIGNING_DIR"

echo "📁 Folder: $(pwd)"
echo ""

# 1) Nađi .cer fajl (ovde ili u Downloads)
CER_FILE=""
if ls *.cer 1>/dev/null 2>&1; then
  CER_FILE=$(ls *.cer 2>/dev/null | head -1)
fi
if [ -z "$CER_FILE" ] && [ -d "$HOME/Downloads" ]; then
  for f in "$HOME"/Downloads/*.cer; do
    [ -f "$f" ] && { CER_FILE="$f"; break; }
  done
  if [ -n "$CER_FILE" ]; then
    cp "$CER_FILE" .
    CER_FILE=$(basename "$CER_FILE")
    echo "✅ Preuzet .cer iz Downloads: $CER_FILE"
  fi
fi
if [ -z "$CER_FILE" ]; then
  echo "❌ Nema .cer fajla ni ovde ni u Downloads. Preuzmi sertifikat od Apple i stavi ga u ovaj folder."
  exit 1
fi
echo "📄 Koristim sertifikat: $CER_FILE"
echo ""

# 2) cert.pem – prvo probaj DER, pa PEM
if openssl x509 -inform DER -in "$CER_FILE" -out cert.pem 2>/dev/null; then
  echo "✅ cert.pem napravljen (DER)"
else
  if openssl x509 -in "$CER_FILE" -out cert.pem 2>/dev/null; then
    echo "✅ cert.pem napravljen (PEM)"
  else
    echo "❌ Ne mogu da pročitam sertifikat: $CER_FILE"
    exit 1
  fi
fi

# 3) Proveri da postoji private_key.key
if [ ! -f "private_key.key" ]; then
  echo "❌ Nema private_key.key u ovom folderu."
  exit 1
fi

# 4) Napravi .p12
echo ""
echo "🔐 Pravim MyChatEra.p12..."
echo "   Kad traži 'Export Password', unesi neku lozinku (npr. mychatera123) i zapamti je za Keychain."
echo ""
openssl pkcs12 -export -out MyChatEra.p12 -inkey private_key.key -in cert.pem -name "MyChatEra Distribution"

echo ""
echo "✅ Gotovo! Sada:"
echo "   1. U Finderu otvori folder MyChatEra_Signing"
echo "   2. Dupli klik na MyChatEra.p12"
echo "   3. Unesi lozinku koju si stavila za .p12 i dodaj u Keychain (login)"
echo ""
