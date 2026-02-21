# Flutter IPA build lokalno (Xcode, bez Codemagica)

Koraci da na svom Mac-u napraviš **novi sertifikat**, **novi provisioning profile** i da **potpišeš i build-uješ IPA** za **ZaMariju** (com.mychatera). Sve se radi u Xcode-u i Terminalu, Codemagic nije potreban.

---

## Šta ti treba

- **Mac** sa Xcode-om (najnovija stabilna verzija)
- **Flutter** instaliran (`flutter doctor`)
- **Apple Developer** nalog (Team ID: `522DMZ83DM`)
- **Bundle ID** u projektu: `com.mychatera`

---

## Deo 1: Novi Apple Distribution sertifikat

Stari sertifikat i kljuć su bili na Scaleway mašini; sada kreiraš sve ispočetka na ovom Mac-u.

### 1.1. Kreiraj CSR (Certificate Signing Request) na Mac-u

1. Otvori **Keychain Access** (Spotlight: „Keychain Access“).
2. Meni: **Keychain Access** → **Certificate Assistant** → **Request a Certificate From a Certificate Authority**.
3. Popuni:
   - **User Email Address:** tvoj Apple ID email.
   - **Common Name:** npr. `MyChatEra Distribution` (bilo koje ime za prepoznavanje).
   - **CA Email Address:** ostavi prazno.
   - **Request is:** izaberi **Saved to disk**.
   - Klikni **Continue**.
4. Ako pita za „key pair“:
   - **Key Size:** 2048 bits.
   - **Algorithm:** RSA.
5. Sačuvaj fajl (npr. na Desktop): `CertificateSigningRequest.certSigningRequest`.

**Važno:** Private key ostaje u Keychain-u na ovom Mac-u. Ne briši ga i ne diži CSR bez potrebe sa računara.

---

### 1.2. Kreiraj Apple Distribution sertifikat u Developer portalu

1. Idi na: [developer.apple.com/account](https://developer.apple.com/account) → **Certificates, Identifiers & Profiles**.
2. Levo: **Certificates** → **+** (novi sertifikat).
3. Izaberi **Apple Distribution** → **Continue**.
4. **Upload** fajl koji si sačuvala (CSR) → **Continue**.
5. Preuzmi **.cer** fajl (npr. `Apple Distribution.cer`).

---

### 1.3. Instaliraj sertifikat na Mac

1. Dupli klik na preuzeti **.cer** fajl.
2. Otvoriće se Keychain Access i sertifikat će biti dodat u **login** keychain.
3. U Keychain Access-u potraži „Apple Distribution: …“ – kada ga proširiš, ispod treba da bude i **private key** (ime koje si dala u CSR). Ako vidiš i cert i key, sve je u redu.

Sada imaš **novi Distribution sertifikat + private key** samo na ovom računaru.

---

## Deo 2: App Store provisioning profile za com.mychatera

### 2.1. Kreiraj profil u Developer portalu

1. [developer.apple.com/account](https://developer.apple.com/account) → **Profiles** (Provisioning profiles) → **+**.
2. Izaberi **App Store** (Distribution) → **Continue**.
3. Izaberi **App ID:** onaj za `com.mychatera` (ako ga nema, prvo kreiraj pod Identifiers).
4. **Certificates:** izaberi **novi** Apple Distribution sertifikat koji si upravo napravila → **Continue**.
5. **Profile Name:** npr. `MyChatEra App Store` (ili `MyChatEraAI Distribution` da odgovara starom imenu u projektu).
6. **Generate** → preuzmi **.mobileprovision** fajl.

---

### 2.2. Instaliraj provisioning profile

- Dupli klik na **.mobileprovision** fajl. Xcode će ga instalirati (ne moraš ništa drugo da radiš u Keychain-u za profil).

---

## Deo 3: Podešavanje Xcode projekta (ZaMariju)

### 3.1. Otvori iOS deo projekta u Xcode-u

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
open ios/Runner.xcworkspace
```

**Koristi `.xcworkspace`**, ne `.xcodeproj` (zbog CocoaPods).

---

### 3.2. Signing u Xcode-u

1. U levom panelu izaberi **Runner** (projekat, plavi ikonica).
2. Izaberi target **Runner** (ne RunnerTests).
3. Tab **Signing & Capabilities**.
4. Uključi **Automatically manage signing** **isključeno** (Manual signing).
5. **Team:** izaberi svoj tim (522DMZ83DM).
6. **Provisioning Profile:** izaberi novi App Store profil koji si kreirala (npr. `MyChatEra App Store` ili `MyChatEraAI Distribution`).
7. **Signing Certificate:** trebalo bi da se automatski izabere **Apple Distribution** (onaj koji si instalirala).

Ako Xcode traži „Repair“ ili nudi druge profile, izaberi novi Distribution profil i Apple Distribution cert.

---

### 3.3. Build konfiguracija za Release/Profile

Proveri da je za **Profile** (ili Release) konfiguracija:

- **Signing:** Manual.
- **Provisioning Profile:** isti onaj koji si izabrala gore.
- **Code Sign Identity:** Apple Distribution.

U tvom projektu je već podešeno `CODE_SIGN_STYLE = Manual` i `PROVISIONING_PROFILE_SPECIFIER = "MyChatEraAI Distribution"`. Ako si novi profil nazvala drugačije, u **Build Settings** za target Runner → **Profile** promeni **Provisioning Profile** na tačno ime novog profila.

---

## Deo 4: Flutter IPA build (Terminal)

Kada su sertifikat i profil instalirani i Xcode ih vidi:

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ipa
```

Možeš menjati verziju i build broj:

```bash
flutter build ipa --build-name=1.0.0 --build-number=9
```

---

## Gde je IPA fajl

Posle uspešnog build-a:

- **Putanja:** `ZaMariju/build/ios/ipa/Runner.ipa`
- Ili u Finderu: `ZaMariju` → `build` → `ios` → `ipa` → `Runner.ipa`.

Ovaj **Runner.ipa** je spreman za upload u App Store Connect (TestFlight / App Store).

---

## Upload u App Store Connect (opciono)

- **Transporter** (App Store aplikacija): otvori Transporter → Add → izaberi `Runner.ipa` → Deliver.
- **Xcode:** Window → Organizer → Archives → izaberi arhivu → Distribute App → App Store Connect → Upload (ako želiš da koristiš arhivu iz Xcode-a; za Flutter IPA obično je dovoljno koristiti IPA iz `flutter build ipa` u Transporteru).

---

## Ako nešto ne radi

- **„No signing certificate“:** Proveri da li je .cer instaliran i da u Keychain-u postoji i private key ispod tog cert-a. Ponovo dupli klik na .cer ako treba.
- **„No provisioning profile for com.mychatera“:** Proveri da App ID u portalu bude tačno `com.mychatera` i da je profil tipa **App Store**, i da si izabrala novi Distribution cert pri kreiranju profila. Ponovo dupli klik na .mobileprovision.
- **„Could not find an option named …“:** Uvek radi `flutter build ipa` iz foldera **ZaMariju** (`cd ZaMariju`).
- **CocoaPods greške:** `cd ZaMariju/ios && pod install` pa ponovo `flutter build ipa`.

---

## Rezime redosleda

1. Keychain: **Request a Certificate** → sačuvaj CSR.
2. developer.apple.com: **Certificates** → **Apple Distribution** → upload CSR → preuzmi .cer.
3. Dupli klik na .cer → instaliran cert + key u Keychain.
4. developer.apple.com: **Profiles** → **App Store** profil za `com.mychatera` sa novim cert-om → preuzmi .mobileprovision.
5. Dupli klik na .mobileprovision.
6. Xcode: otvori `ZaMariju/ios/Runner.xcworkspace` → Signing & Capabilities → Manual, izaberi novi profil i Apple Distribution.
7. Terminal: `cd ZaMariju` → `flutter build ipa`.
8. IPA: `ZaMariju/build/ios/ipa/Runner.ipa`.

Ako želiš, napiši na kom koraku zapneš (i tačnu poruku greške) pa mogu da skratim korake samo za to.
