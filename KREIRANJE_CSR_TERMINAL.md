# Kreiranje CSR i private key preko Terminala (bez Certificate Assistant)

Koristiš **Terminal** i **OpenSSL** – Certificate Assistant ti ne treba.

---

## Korak 1: Otvori Terminal

- Spotlight: **⌘ + Space** → ukucaj **Terminal** → Enter  
- Ili: **Finder → Applications → Utilities → Terminal**

---

## Korak 2: Napravi folder za sertifikat (npr. na Desktopu)

U Terminalu ukucaj (možeš kopirati ceo blok i nalepiti):

```bash
mkdir -p ~/Desktop/MyChatEra_Signing
cd ~/Desktop/MyChatEra_Signing
```

Pritisni **Enter**.

---

## Korak 3: Generiši private key

```bash
openssl genrsa -out private_key.key 2048
```

Pritisni **Enter**. Ne treba ništa da unosiš – biće kreiran fajl `private_key.key`.  
**Važno:** Ovaj fajl **čuvaj na sigurnom mestu** i nikome ga ne šalji.

---

## Korak 4: Generiši CSR (Certificate Signing Request)

Zameni **TVOJ_APPLE_ID_EMAIL** svojim pravim Apple ID emailom (npr. `ime@gmail.com`), pa u Terminalu ukucaj **jednu** od ove dve varijante.

**Varijanta A – sve u jednoj komandi (zameni email):**

```bash
openssl req -new -key private_key.key -out CertificateSigningRequest.certSigningRequest -subj "/emailAddress=TVOJ_APPLE_ID_EMAIL/CN=MyChatEra Distribution/C=US"
```

**Primer** (ako je email `marija@gmail.com`):

```bash
openssl req -new -key private_key.key -out CertificateSigningRequest.certSigningRequest -subj "/emailAddress=marija@gmail.com/CN=MyChatEra Distribution/C=US"
```

**Varijanta B – interaktivno (ako želiš da Terminal pita za podatke):**

```bash
openssl req -new -key private_key.key -out CertificateSigningRequest.certSigningRequest
```

Terminal će tražiti:
- **Country Name:** npr. `US` ili `RS`
- **State:** npr. `Serbia` ili ostavi prazno, Enter
- **Locality:** npr. grad ili Enter
- **Organization:** npr. tvoje ime ili „MyChatEra“
- **Common Name:** npr. `MyChatEra Distribution`
- **Email:** tvoj **Apple ID email**
- Ostalo možeš ostaviti prazno (Enter).

---

## Korak 5: Proveri da imaš oba fajla

U Terminalu:

```bash
ls -la
```

Trebalo bi da vidiš:
- `private_key.key` – **private key (čuvaj ga!)**
- `CertificateSigningRequest.certSigningRequest` – **CSR** (ovo šalješ Apple-u)

---

## Korak 6: Šta da uradiš u Apple Developer portalu

1. Idi na: https://developer.apple.com/account → **Certificates, Identifiers & Profiles**.
2. **Certificates** → **+** (novi sertifikat).
3. Izaberi **Apple Distribution** → **Continue**.
4. Klikni **Choose File** i izaberi fajl:  
   **Desktop → MyChatEra_Signing → CertificateSigningRequest.certSigningRequest**
5. **Continue** → **Download** – preuzmi **.cer** fajl (npr. `Apple Distribution.cer`).
6. Sačuvaj ga u isti folder: **Desktop → MyChatEra_Signing**.

---

## Korak 7: Ubaci private key u Keychain (da Xcode može da ga koristi)

1. Otvori **Keychain Access** (Spotlight: „Keychain Access“).
2. U meniju: **File → Import Items…** (ili **Import Items…**).
3. Idi u **Desktop → MyChatEra_Signing**.
4. Izaberi fajl **private_key.key** (ako ne vidiš, u „Enable“ izaberi **All Files**).
5. **Open** → možda će tražiti lozinku za „login“ keychain (tvoja Mac lozinka) – unesi je.
6. Private key sada treba da se vidi u Keychain Access-u u listi (tip: „private key“).

---

## Korak 8: Instaliraj sertifikat (.cer) u Keychain

1. Na **Desktopu** u folderu **MyChatEra_Signing** nađi preuzeti **.cer** fajl.
2. **Dupli klik** na njega.
3. Otvoriće se Keychain Access – sertifikat će biti dodat u **login**.
4. U Keychain Access-u potraži „**Apple Distribution**“ (ili slično). Kada proširiš taj sertifikat (strelica pored), ispod njega treba da bude **private key** koji si uvezla u koraku 7. To znači da su cert i ključ povezani i spremni za potpis.

---

## Korak 9: Nastavi sa vodičem za IPA

Sada imaš:
- novi **Apple Distribution** sertifikat u Keychain-u,
- **private key** u Keychain-u,
- fajl **private_key.key** na Desktopu u **MyChatEra_Signing** (čuvaj ga kao rezervu, ne briši).

Nastavi po vodiču **LOCAL_FLUTTER_IPA_BUILD.md**:  
**Deo 2** (Provisioning profile) → **Deo 3** (Xcode) → **Deo 4** (Flutter build IPA).

---

## Ukratko – šta si uradila

1. **Terminal:** `openssl genrsa` → `private_key.key`  
2. **Terminal:** `openssl req -new -key ...` → `CertificateSigningRequest.certSigningRequest`  
3. **Apple portal:** upload CSR → preuzmeš **.cer**  
4. **Keychain Access:** File → Import Items → **private_key.key**  
5. **Dupli klik** na **.cer** → cert i key su u Keychain-u, spremno za Xcode i Flutter IPA.

Ako negde zapneš, napiši koji korak i šta tačno piše na ekranu (ili greška).
