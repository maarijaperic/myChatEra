# Logo Setup Guide

## Kako dodati logo u aplikaciju

### Korak 1: Pripremi logo fajl

1. Logo treba da bude PNG format
2. Preporučena veličina: **512x512 px** (ili veća, kvadratna)
3. Nazovi fajl: `logo.png`

### Korak 2: Dodaj logo u projekat

1. Kreiraj folder `assets/images/` u root direktorijumu projekta (ako ne postoji):
   ```
   ZaMariju/
     assets/
       images/
         logo.png
   ```

2. Dodaj logo fajl u `assets/images/logo.png`

### Korak 3: Verifikuj pubspec.yaml

Proveri da li je `pubspec.yaml` već konfigurisan (trebalo bi da već jeste):

```yaml
flutter:
  assets:
    - assets/images/
```

### Korak 4: Pokreni flutter pub get

```bash
cd ZaMariju
flutter pub get
```

### Korak 5: Testiraj

Pokreni aplikaciju i proveri da li se logo prikazuje na splash screenu.

## Napomene

- Ako logo ne postoji, aplikacija će automatski koristiti placeholder (gradient speech bubble)
- Logo se prikazuje na splash screenu (početni ekran)
- Možeš koristiti i druge formate (JPG, SVG), ali PNG je preporučen

## Troubleshooting

**Logo se ne prikazuje:**
1. Proveri da li fajl postoji na putanji `assets/images/logo.png`
2. Proveri da li je `pubspec.yaml` ažuriran sa `assets: - assets/images/`
3. Pokreni `flutter clean` i `flutter pub get`
4. Restartuj aplikaciju

**Logo je previše velik/mali:**
- Promeni veličinu u `screen_splash.dart`:
  ```dart
  Image.asset(
    'assets/images/logo.png',
    width: 150,  // Promeni ovu vrednost
    height: 150, // Promeni ovu vrednost
  )
  ```


