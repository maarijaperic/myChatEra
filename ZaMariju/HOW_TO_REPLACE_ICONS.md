# 🔄 Kako Zameniti Ikone Nakon Generisanja na appicon.co

## Korak 1: Download ikone sa appicon.co

1. Idi na **https://www.appicon.co/**
2. Upload tvoj logo (1024x1024)
3. Izaberi **"iOS"**
4. Klikni **"Generate"**
5. Download-uj **ZIP fajl**

## Korak 2: Raspakuj ZIP fajl

ZIP fajl će sadržati folder sa svim ikonama. Raspakuj ga negde gde možeš lako da pristupiš.

## Korak 3: Zameni fajlove

### Opcija A: Preko Finder-a (macOS)

1. Otvori **Finder**
2. Idi na: `~/Documents/myChatEra/ZaMariju/ios/Runner/Assets.xcassets/AppIcon.appiconset/`
3. **Backup-uj postojeće ikone** (kopiraj folder negde za slučaj)
4. **Zameni sve PNG fajlove** sa novim ikonama iz appicon.co ZIP-a
5. **VAŽNO**: Zadrži isti naziv fajlova! (npr. `Icon-App-1024x1024@1x.png`)

### Opcija B: Preko Terminala

```bash
# 1. Idi u folder gde si raspakovala ikone (iz appicon.co ZIP-a)
cd /path/to/AppIcon.appiconset

# 2. Idi u AppIcon folder projekta
cd ~/Documents/myChatEra/ZaMariju/ios/Runner/Assets.xcassets/AppIcon.appiconset/

# 3. Backup postojećih ikona (opciono)
mkdir -p ~/Desktop/icon-backup
cp *.png ~/Desktop/icon-backup/

# 4. Kopiraj nove ikone (zameni /path/to sa pravom putanjom)
cp /path/to/AppIcon.appiconset/*.png .

# 5. Proveri da li su sve ikone kopirane
ls -lh *.png
```

## Korak 4: Verifikacija

### Proveri u Xcode:
1. Otvori `Runner.xcworkspace`
2. Klikni na "Assets.xcassets" → "AppIcon"
3. Trebalo bi da vidiš sve ikone popunjene

### Proveri preko Terminala:
```bash
cd ~/Documents/myChatEra/ZaMariju/ios/Runner/Assets.xcassets/AppIcon.appiconset/
ls -lh *.png

# Trebalo bi da vidiš sve ikone:
# - Icon-App-1024x1024@1x.png (1024x1024)
# - Icon-App-60x60@3x.png (180x180)
# - Icon-App-60x60@2x.png (120x120)
# - itd...
```

## Korak 5: Test Build

```bash
cd ~/Documents/myChatEra/ZaMariju
flutter run

# Proveri da li se logo pojavljuje na home screen-u simulatora
```

## ⚠️ VAŽNO: Nazivi Fajlova

**MORAŠ zadržati iste nazive fajlova!**

- `Icon-App-1024x1024@1x.png` → **1024x1024**
- `Icon-App-60x60@3x.png` → **180x180**
- `Icon-App-60x60@2x.png` → **120x120**
- `Icon-App-40x40@3x.png` → **120x120**
- `Icon-App-40x40@2x.png` → **80x80**
- `Icon-App-40x40@1x.png` → **40x40**
- `Icon-App-29x29@3x.png` → **87x87**
- `Icon-App-29x29@2x.png` → **58x58**
- `Icon-App-29x29@1x.png` → **29x29**
- `Icon-App-20x20@3x.png` → **60x60**
- `Icon-App-20x20@2x.png` → **40x40**
- `Icon-App-20x20@1x.png` → **20x20**
- `Icon-App-76x76@2x.png` → **152x152** (iPad)
- `Icon-App-76x76@1x.png` → **76x76** (iPad)
- `Icon-App-83.5x83.5@2x.png` → **167x167** (iPad Pro)

## 🆘 Problem: Fajlovi imaju drugačije nazive

Ako appicon.co generiše fajlove sa drugačijim nazivima:

1. **Preimenuj fajlove** da odgovaraju nazivima iz `Contents.json`
2. ILI **ručno kopiraj** svaki fajl sa pravim nazivom

## ✅ Provera da li je sve OK

Nakon zamene, proveri:

```bash
cd ~/Documents/myChatEra/ZaMariju/ios/Runner/Assets.xcassets/AppIcon.appiconset/

# Proveri da li postoje svi fajlovi
ls -lh Icon-App-*.png | wc -l
# Trebalo bi da vidiš oko 15 fajlova

# Proveri veličine
file Icon-App-1024x1024@1x.png
# Trebalo bi da piše: "PNG image data, 1024 x 1024"
```

**Spremno za build!** 🚀


