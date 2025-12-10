# 🗺️ Mapiranje Naziva Ikona: appicon.co → iOS Nazivi

## Kako Zameniti Fajlove sa Brojevima u Pravim Nazivima

appicon.co generiše fajlove sa nazivima kao `icon-1024.png`, `icon-180.png`, itd.
Treba da ih preimenuješ u iOS nazive kao `Icon-App-1024x1024@1x.png`, `Icon-App-60x60@3x.png`, itd.

---

## 📋 MAPIRANJE: Veličina → iOS Naziv

| appicon.co Naziv | Veličina | iOS Naziv |
|------------------|----------|-----------|
| `icon-1024.png` | 1024x1024 | `Icon-App-1024x1024@1x.png` |
| `icon-180.png` | 180x180 | `Icon-App-60x60@3x.png` |
| `icon-120.png` | 120x120 | `Icon-App-60x60@2x.png` |
| `icon-87.png` | 87x87 | `Icon-App-29x29@3x.png` |
| `icon-80.png` | 80x80 | `Icon-App-40x40@2x.png` |
| `icon-76.png` | 76x76 | `Icon-App-76x76@1x.png` |
| `icon-60.png` | 60x60 | `icon-60.png` → **2 fajla!** |
| | | → `Icon-App-40x40@3x.png` (60x60) |
| | | → `Icon-App-20x20@3x.png` (60x60) |
| `icon-58.png` | 58x58 | `Icon-App-29x29@2x.png` |
| `icon-40.png` | 40x40 | `icon-40.png` → **2 fajla!** |
| | | → `Icon-App-40x40@1x.png` (40x40) |
| | | → `Icon-App-20x20@2x.png` (40x40) |
| `icon-29.png` | 29x29 | `Icon-App-29x29@1x.png` |
| `icon-20.png` | 20x20 | `Icon-App-20x20@1x.png` |
| `icon-167.png` | 167x167 | `Icon-App-83.5x83.5@2x.png` (iPad Pro) |
| `icon-152.png` | 152x152 | `Icon-App-76x76@2x.png` (iPad) |

---

## 🔄 Kako Preimenovati Fajlove

### Opcija A: Ručno Preko Finder-a

1. Otvori folder gde si raspakovala ZIP (`AppIcon.appiconset` ili slično)
2. Za svaki fajl:
   - `icon-1024.png` → Kopiraj kao `Icon-App-1024x1024@1x.png`
   - `icon-180.png` → Kopiraj kao `Icon-App-60x60@3x.png`
   - `icon-120.png` → Kopiraj kao `Icon-App-60x60@2x.png`
   - itd...

### Opcija B: Preko Terminala (Najlakše!)

```bash
# 1. Idi u folder gde si raspakovala ikone
cd ~/Desktop/AppIcon.appiconset  # ILI gde god si raspakovala

# 2. Preimenuj fajlove
mv icon-1024.png Icon-App-1024x1024@1x.png
mv icon-180.png Icon-App-60x60@3x.png
mv icon-120.png Icon-App-60x60@2x.png
mv icon-87.png Icon-App-29x29@3x.png
mv icon-80.png Icon-App-40x40@2x.png
mv icon-76.png Icon-App-76x76@1x.png
mv icon-60.png Icon-App-40x40@3x.png
mv icon-58.png Icon-App-29x29@2x.png
mv icon-40.png Icon-App-40x40@1x.png
mv icon-29.png Icon-App-29x29@1x.png
mv icon-20.png Icon-App-20x20@1x.png
mv icon-167.png Icon-App-83.5x83.5@2x.png
mv icon-152.png Icon-App-76x76@2x.png

# 3. Kopiraj dodatne ikone koje koriste istu veličinu
# (icon-60.png i icon-40.png se koriste za više mesta)

# Za icon-60.png (60x60):
cp Icon-App-40x40@3x.png Icon-App-20x20@3x.png

# Za icon-40.png (40x40):
cp Icon-App-40x40@1x.png Icon-App-20x20@2x.png

# 4. Kopiraj sve u AppIcon folder projekta
cp *.png ~/Documents/myChatEra/ZaMariju/ios/Runner/Assets.xcassets/AppIcon.appiconset/
```

---

## 🎯 KOMPLETAN SCRIPT (Kopiraj i Pokreni)

```bash
#!/bin/bash

# 1. Idi u folder gde si raspakovala ikone
cd ~/Desktop/AppIcon.appiconset  # PROMENI OVO SA PRAVOM PUTANJOM!

# 2. Preimenuj sve fajlove
mv icon-1024.png Icon-App-1024x1024@1x.png 2>/dev/null
mv icon-180.png Icon-App-60x60@3x.png 2>/dev/null
mv icon-120.png Icon-App-60x60@2x.png 2>/dev/null
mv icon-87.png Icon-App-29x29@3x.png 2>/dev/null
mv icon-80.png Icon-App-40x40@2x.png 2>/dev/null
mv icon-76.png Icon-App-76x76@1x.png 2>/dev/null
mv icon-60.png Icon-App-40x40@3x.png 2>/dev/null
mv icon-58.png Icon-App-29x29@2x.png 2>/dev/null
mv icon-40.png Icon-App-40x40@1x.png 2>/dev/null
mv icon-29.png Icon-App-29x29@1x.png 2>/dev/null
mv icon-20.png Icon-App-20x20@1x.png 2>/dev/null
mv icon-167.png Icon-App-83.5x83.5@2x.png 2>/dev/null
mv icon-152.png Icon-App-76x76@2x.png 2>/dev/null

# 3. Kopiraj ikone koje se koriste na više mesta
cp Icon-App-40x40@3x.png Icon-App-20x20@3x.png 2>/dev/null
cp Icon-App-40x40@1x.png Icon-App-20x20@2x.png 2>/dev/null

# 4. Kopiraj sve u AppIcon folder projekta
cp *.png ~/Documents/myChatEra/ZaMariju/ios/Runner/Assets.xcassets/AppIcon.appiconset/

echo "✅ Ikone su preimenovane i kopirane!"
echo "📋 Proveri:"
ls -lh ~/Documents/myChatEra/ZaMariju/ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png
```

---

## 🔍 Kako Proveriti Koje Fajlove Imaš

```bash
# Idi u folder gde si raspakovala ikone
cd ~/Desktop/AppIcon.appiconset  # ILI gde god si raspakovala

# Lista svih fajlova
ls -lh icon-*.png

# Trebalo bi da vidiš nešto kao:
# icon-1024.png
# icon-180.png
# icon-120.png
# icon-87.png
# itd...
```

---

## ⚠️ VAŽNO: Duplikati

Neki fajlovi se koriste na više mesta:
- `icon-60.png` (60x60) → koristi se za `Icon-App-40x40@3x.png` I `Icon-App-20x20@3x.png`
- `icon-40.png` (40x40) → koristi se za `Icon-App-40x40@1x.png` I `Icon-App-20x20@2x.png`

Zato kopiraj te fajlove sa oba naziva!

---

## ✅ FINALNA PROVERA

Nakon što preimenuješ i kopiraš:

```bash
cd ~/Documents/myChatEra/ZaMariju/ios/Runner/Assets.xcassets/AppIcon.appiconset/

# Proveri da li postoje svi fajlovi
ls -lh Icon-App-*.png

# Trebalo bi da vidiš oko 15 fajlova sa pravim nazivima
```

**Spremno za build!** 🚀


