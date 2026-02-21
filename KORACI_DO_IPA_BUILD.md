# Koraci do uspešnog Flutter IPA build-a (Keychain već dodat)

Sertifikat i ključ su u Keychain-u (login). "Nije trusted" za Apple Distribution je uobičajeno – za potpisivanje je OK.

Sledi: **Provisioning profile** → **Xcode** → **Flutter build**.

---

## KORAK 1: App Store provisioning profile (Apple Developer)

1. Otvori browser → **https://developer.apple.com/account** → uloguj se.
2. Levo: **Profiles** (Provisioning Profiles) → klikni **+**.
3. Izaberi **App Store** (pod Distribution) → **Continue**.
4. **App ID:** izaberi **com.mychatera** → **Continue**.
   - Ako nema: **Identifiers** → **+** → App IDs → **App** → Bundle ID **com.mychatera** → Register. Zatim se vrati na **Profiles** → **+**.
5. **Certificates:** izaberi **Apple Distribution** (tvoj novi cert) → **Continue**.
6. **Profile Name:** npr. **MyChatEraAI Distribution** → **Generate**.
7. **Download** → sačuvaj **.mobileprovision** fajl.
8. Na Mac-u **dupli klik** na **.mobileprovision** da se instalira (ništa više ne treba za profil).

---

## KORAK 2: Xcode – potpisivanje

1. Otvori **Terminal** i ukucaj (kopiraj obe linije, Enter posle druge):

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
open ios/Runner.xcworkspace
```

2. U Xcode-u:
   - Levo: klikni **Runner** (plava ikonica na vrhu).
   - Sredina: izaberi target **Runner** (ne RunnerTests).
   - Gore: kartica **Signing & Capabilities**.

3. Podesi:
   - **Automatically manage signing** = **isključeno** (Manual).
   - **Team** = tvoj tim (npr. 522DMZ83DM).
   - **Provisioning Profile** = **MyChatEraAI Distribution** (ili tačno ime profila iz Koraka 1).
   - **Signing Certificate** = **Apple Distribution**.

4. Ako ima crvenih grešaka: proveri da li je profil zaista instaliran (dupli klik na .mobileprovision) i da u Keychain-u postoji Apple Distribution sa private key ispod. Zatvori Xcode, ponovo otvori **Runner.xcworkspace**, pa proveri Signing opet.

5. **⌘ + S** (Save). Možeš zatvoriti Xcode.

---

## KORAK 3: Flutter IPA build (Terminal)

1. Otvori **Terminal** (ili ostani u njemu).

2. Redom ukucaj i pritisni **Enter** posle svake linije:

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
```

```bash
flutter clean
```

```bash
flutter pub get
```

```bash
cd ios && pod install && cd ..
```

```bash
flutter build ipa
```

3. Sačekaj da se build završi (nekoliko minuta). Na kraju treba da piše da je uspešan.

---

## KORAK 4: Gde je IPA

- **Putanja:**  
  **ZaMariju/build/ios/ipa/Runner.ipa**

- U Finderu: **myChatEra** → **ZaMariju** → **build** → **ios** → **ipa** → **Runner.ipa**.

- Za App Store / TestFlight: otvori aplikaciju **Transporter** (App Store), dodaj **Runner.ipa**, pošalji.

---

## Ako nešto ne radi

- **"No signing certificate" / "No valid signing identity"**  
  Proveri Keychain: za „Apple Distribution“ proširi cert (strelica) – ispod treba da bude private key. Ako nema, ponovo dupli klik na **MyChatEra.p12** i import u **login**.

- **"No profiles for 'com.mychatera'"**  
  Kreiraj profil (Korak 1), preuzmi .mobileprovision, dupli klik da se instalira. U Xcode-u izaberi taj profil u **Provisioning Profile**.

- **CocoaPods / pod install greška**  
  U Terminalu: `cd /Users/m1/Desktop/myChatEra/ZaMariju/ios && pod install`, pa ponovo `flutter build ipa`.

- **"Building for iOS, but the linked framework ..."**  
  U Xcode-u: **Product → Clean Build Folder**, zatim u Terminalu ponovo `flutter clean` pa `flutter build ipa`.

Ako zapneš, napiši tačnu poruku greške i na kom koraku (1, 2, 3 ili 4).
