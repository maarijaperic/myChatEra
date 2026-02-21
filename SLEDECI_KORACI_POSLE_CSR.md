# Sledeći koraci – detaljno (posle što si napravila CSR)

Imaš već u folderu **MyChatEra_Signing** na Desktopu:
- `private_key.key`
- `CertificateSigningRequest.certSigningRequest`

Sada redom radi ovo.

---

# DEO A: Apple Distribution sertifikat u Developer portalu

## Korak A1: Otvori Apple Developer

1. Otvori **Safari** (ili drugi browser).
2. Idi na: **https://developer.apple.com/account**
3. Uloguj se sa svojim **Apple ID** (email + lozinka).

---

## Korak A2: Certificates, Identifiers & Profiles

1. Na stranici naloga trebalo bi da vidiš karticu ili link: **Certificates, Identifiers & Profiles**.
2. Klikni na **Certificates, Identifiers & Profiles** (ili **Account** pa onda to).

---

## Korak A3: Novi sertifikat

1. U levom meniju nađi **Certificates** (pod „Identifiers“ obično).
2. Klikni **Certificates**.
3. Na stranici sa listom sertifikata nađi plavo dugme **+** (plus) – „Add“ ili „Create“ – i klikni ga.

---

## Korak A4: Izaberi tip sertifikata

1. Prikazaće se lista tipova (Development, Distribution, itd.).
2. Izaberi **Apple Distribution** (ne Development, ne „Apple Development“).
3. Klikni **Continue** (dole desno).

---

## Korak A5: Upload CSR fajla

1. Stranica će reći da treba da uuploaduješ **Certificate Signing Request**.
2. Klikni **Choose File** (ili „Select File“, „Izaberi fajl“).
3. U dijalogu:
   - Idi na **Desktop**.
   - Otvori folder **MyChatEra_Signing**.
   - Izaberi fajl **CertificateSigningRequest.certSigningRequest**.
   - Klikni **Open** (ili „Izaberi“).
4. Kada se fajl učita, klikni **Continue** na stranici.

---

## Korak A6: Preuzmi .cer fajl

1. Sledeća stranica će reći da je sertifikat kreiran.
2. Klikni **Download** (da preuzmeš sertifikat).
3. Fajl će se preuzeti (npr. **Apple Distribution.cer** ili slično ime).
4. **Premesti ovaj .cer fajl** u folder **Desktop → MyChatEra_Signing** (da ti sve bude na jednom mestu).  
   (U Finderu: Downloads → nađi .cer → prevuci ga u MyChatEra_Signing ili Copy/Paste.)

**Deo A je gotov** – imaš Apple Distribution sertifikat (.cer).

---

# DEO B: Private key i sertifikat u Keychain (da Mac i Xcode znaju za njih)

## Korak B1: Otvori Keychain Access

1. Pritisni **⌘ + Space** (Spotlight).
2. Ukucaj **Keychain Access**.
3. Pritisni **Enter**.

---

## Korak B2: Ubaci private key u Keychain

1. U Keychain Access-u u gornjem meniju klikni **File**.
2. Klikni **Import Items…** (ili samo „Import…“).
3. U dijalogu:
   - Idi na **Desktop → MyChatEra_Signing**.
   - Ako ne vidiš **private_key.key**, u padajućem meniju za tip fajlova izaberi **All Files** ili **Svi fajlovi**.
   - Klikni na **private_key.key**.
   - Klikni **Open**.
4. Možda će iskočiti prozor koji pita u koji keychain – izaberi **login** (ako nudi) i **Add** ili **OK**.
5. Ako pita lozinku za „login keychain“, unesi svoju **Mac prijavnu lozinku** i potvudi.
6. Sada u listi u Keychain Access-u trebalo bi da postoji unos tipa **private key** (ime može biti „private_key“ ili slično). To je tvoj ključ.

---

## Korak B3: Instaliraj sertifikat (.cer) u Keychain

1. Otvori **Finder**.
2. Idi na **Desktop → MyChatEra_Signing**.
3. Nađi fajl **Apple Distribution.cer** (ili kako god se zove preuzeti .cer).
4. **Dupli klik** na taj .cer fajl.
5. Otvoriće se Keychain Access (ako već nije otvoren) i sertifikat će biti dodat u keychain (obično **login**).
6. U Keychain Access-u u listi nađi **Apple Distribution** (ili „Apple Distribution: tvoje ime“). Klikni na strelicu pored njega da ga **proširiš**. Ispod treba da vidiš **private key** (isti onaj koji si uvezla u B2). Ako vidiš i cert i key zajedno – **sve je u redu**, Mac i Xcode mogu da koriste ovaj sertifikat za potpis.

**Deo B je gotov** – cert i key su u Keychain-u.

---

# DEO C: App Store provisioning profile (za aplikaciju com.mychatera)

## Korak C1: Profili u Developer portalu

1. Ostani na **https://developer.apple.com/account** (ili ponovo idi tamo i uloguj se).
2. U levom meniju nađi **Profiles** („Provisioning Profiles“).
3. Klikni **Profiles**.

---

## Korak C2: Novi profil

1. Na stranici sa listom profila nađi dugme **+** (plus) i klikni ga.
2. Trebalo bi da vidiš tipove: Development, Distribution, itd.

---

## Korak C3: Tip profila

1. Izaberi **App Store** (pod Distribution) – **ne** Development, **ne** Ad Hoc.
2. Klikni **Continue**.

---

## Korak C4: App ID

1. Prikazaće se lista **App IDs**.
2. Nađi i izaberi onaj sa **com.mychatera** (može biti prikazan kao „App“ ili ime aplikacije).
3. Ako nema **com.mychatera**, moraš prvo da kreiraš App ID: u levom meniju **Identifiers** → **+** → **App IDs** → **App** → Description npr. „MyChatEra“, Bundle ID **Explicit** → **com.mychatera** → Register. Zatim se vrati na Profiles → **+** i nastavi od C3.
4. Kada izabereš **com.mychatera**, klikni **Continue**.

---

## Korak C5: Sertifikat

1. Prikazaće se lista sertifikata.
2. Izaberi **Apple Distribution** sertifikat koji si upravo napravila (trebalo bi da bude jedan ili prvi u listi – gledaj datum da bude današnji).
3. Klikni **Continue**.

---

## Korak C6: Ime profila i preuzimanje

1. U polje **Profile Name** unesi npr.: **MyChatEraAI Distribution** (može i „MyChatEra App Store“ – zapamti šta si stavila).
2. Klikni **Generate** (ili „Register“).
3. Na sledećoj stranici klikni **Download** da preuzmeš **.mobileprovision** fajl.
4. **Premesti** ovaj fajl u **Desktop → MyChatEra_Signing** (opciono, da ti sve bude na jednom mestu).

---

## Korak C7: Instalacija profila na Mac

1. U **Finderu** nađi preuzeti **.mobileprovision** fajl (npr. **MyChatEraAI_Distribution.mobileprovision**).
2. **Dupli klik** na njega.
3. Možda će se otvoriti Xcode ili samo poruka da je profil instaliran – to je dovoljno. Profil je sada na tvom Mac-u i Xcode ga može koristiti.

**Deo C je gotov** – imaš App Store profil za com.mychatera.

---

# DEO D: Xcode – podešavanje potpisivanja

## Korak D1: Otvori projekat u Xcode-u

1. Otvori **Terminal** (⌘ + Space → „Terminal“).
2. Ukucaj (ili kopiraj) i pritisni Enter:

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
open ios/Runner.xcworkspace
```

3. Otvoriće se **Xcode** sa projektom. Koristi **Runner.xcworkspace**, ne .xcodeproj.

---

## Korak D2: Izaberi projekat i target

1. U **levom panelu** u Xcode-u („Project navigator“) na vrhu trebalo bi da vidiš **Runner** (plava ikonica projekta). Klikni na **Runner** (na sam vrh liste).
2. U sredini ekrana, ispod „TARGETS“, nađi **Runner** (ne RunnerTests) i klikni na njega.
3. Gore izaberi karticu **Signing & Capabilities**.

---

## Korak D3: Manual signing i izbor profila

1. Proveri da je uključeno **Manual** signing (npr. checkbox „Automatically manage signing“ treba da bude **isključen**).
2. **Team:** u padajućem meniju izaberi svoj tim (npr. onaj sa Team ID **522DMZ83DM**).
3. **Provisioning Profile:** u padajućem meniju izaberi profil koji si napravila – **MyChatEraAI Distribution** (ili tačno ono ime koje si dala u C6).
4. **Signing Certificate:** obično će Xcode sam izabrati **Apple Distribution**; ako ne, izaberi **Apple Distribution** ručno.

Ako Xcode prijavi grešku (npr. „No signing certificate“), proveri da li u Keychain Access-u zaista vidiš Apple Distribution cert sa private key ispod (Deo B). Zatvori Xcode, ponovo otvori **Runner.xcworkspace** i proveri Signing & Capabilities opet.

**Deo D je gotov** kada nema crvenih grešaka i vidiš izabran Team, Profile i Apple Distribution.

---

# DEO E: Flutter IPA build (Terminal)

## Korak E1: Očisti i dohvati zavisnosti

U **Terminalu** ukucaj redom (nakon svake grupe pritisni Enter):

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

---

## Korak E2: Build IPA

U Terminalu (i dalje iz foldera ZaMariju, tj. nakon `cd ..` trebalo bi da si u **ZaMariju**):

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
flutter build ipa
```

Ako želiš konkretnu verziju i build broj:

```bash
flutter build ipa --build-name=1.0.0 --build-number=9
```

Sačekaj da se build završi (može nekoliko minuta). Na kraju trebalo bi da piše da je build uspešan.

---

## Korak E3: Gde je IPA

1. U **Finderu** idi na:
   - **Desktop → myChatEra → ZaMariju → build → ios → ipa**
2. Tu trebalo bi da bude fajl **Runner.ipa**. To je tvoja aplikacija spremna za App Store / TestFlight.

Za upload u App Store: otvori aplikaciju **Transporter** (iz App Store-a), dodaj **Runner.ipa** i pošalji.

---

# Rezime redosleda

| Deo | Šta radiš |
|-----|------------|
| **A** | developer.apple.com → Certificates → + → Apple Distribution → upload CSR → Download .cer |
| **B** | Keychain Access → Import **private_key.key** → dupli klik na **.cer** |
| **C** | developer.apple.com → Profiles → + → App Store → com.mychatera → izaberi cert → Profile name → Download .mobileprovision → dupli klik na .mobileprovision |
| **D** | Xcode: otvori ZaMariju/ios/Runner.xcworkspace → Runner target → Signing & Capabilities → Manual, Team, Profile, Apple Distribution |
| **E** | Terminal: cd ZaMariju → flutter clean → flutter pub get → cd ios && pod install && cd .. → flutter build ipa → IPA je u ZaMariju/build/ios/ipa/Runner.ipa |

Ako zapneš na nekom koraku, napiši koji (npr. „Korak A5“ ili „Deo C“) i šta tačno vidiš na ekranu ili koja je poruka greške.
