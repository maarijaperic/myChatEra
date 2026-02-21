# Kako da rešiš "Development Team" grešku i pogrešan sertifikat

## Problem 1: xcodebuild ne vidi build settings (iOS platform nije instalirana)

Poruka **"Found no destinations"** / **"iOS 18.4 is not installed"** znači da Xcode nema instaliran iOS SDK koji treba za build. Zbog toga Flutter ne može da pročita DEVELOPMENT_TEAM iz projekta i prijavi grešku.

### Šta da uradiš

1. Otvori **Xcode**.
2. Idi u **Xcode → Settings** (ili **Preferences**).
3. Otvori karticu **Platforms** (ili **Components** na starijim verzijama).
4. Proveri da li je **iOS** (npr. **iOS 18.4** ili najnovija verzija) **preuzeta i instalirana**.
5. Ako piše **Get** ili **Download** – klikni i sačekaj da se preuzme i instalira.
6. Kada se instalacija završi, zatvori Xcode i ponovo pokreni:

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
./build_ipa.sh
```

Nakon toga `xcodebuild -showBuildSettings` bi trebalo da radi i Flutter da vidi DEVELOPMENT_TEAM iz projekta.

---

## Problem 2: Hvata se pogrešan Apple Distribution sertifikat

Ako u **Keychain Access** imaš više **Apple Distribution** sertifikata (npr. stari opozvani i novi), Xcode/Flutter može da izabere stari i build će failovati.

### Šta da uradiš

1. Otvori **Keychain Access** (Spotlight: Keychain Access).
2. Levo izaberi **login** (ili **System**).
3. U pretragu ukucaj **Apple Distribution** ili **Distribution**.
4. Proveri listu:
   - **Novi cert** – onaj koji si napravila (sa .p12) – treba da bude **validan** (nema "This certificate has been revoked").
   - **Stari cert** – ako postoji i piše **revoked** ili **expired**, obriši ga:
     - Desni klik na cert → **Delete "Apple Distribution: ..."** → potvrdi (po potrebi unesi Mac lozinku).
5. Ostavi **samo jedan** Apple Distribution cert – onaj koji je **validan** i koji odgovara profilu **MyChatEraAI Distribution2**.
6. Zatvori Keychain i ponovo pokreni build.

---

## Provera nakon izmena

U Terminalu (da vidiš da li Xcode sada vidi postavke):

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju/ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -sdk iphoneos -destination 'generic/platform=iOS' -showBuildSettings 2>&1 | grep DEVELOPMENT_TEAM
```

Trebalo bi da vidiš nešto kao: `DEVELOPMENT_TEAM = 522DMZ83DM`

Ako to vidiš, onda pokreni:

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
./build_ipa.sh
```
