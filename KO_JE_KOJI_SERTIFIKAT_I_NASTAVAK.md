# Ko je koji sertifikat / ključ – i nastavak rada

---

## Ko je šta (da ne bude zbunjujuće)

### 1. Šta si napravila **u Terminalu** (OpenSSL)

- **private_key.key**  
  To **nije** sertifikat. To je samo **privatni ključ** (tajna polovina para ključeva). Ostaje na tvom računaru i nikome se ne šalje.

- **CertificateSigningRequest.certSigningRequest** (CSR)  
  To **nije** sertifikat. To je **zahtev** za sertifikat. Taj fajl si poslala Apple-u (upload u Developer portalu). Posle što Apple izda sertifikat, CSR ti više ne treba za dalji rad.

### 2. Šta si dobila **od Apple-a** (Developer portal)

- **Apple Distribution.cer** (ili slično ime)  
  To **jeste** sertifikat. Apple ga je napravio kada si uploadovala CSR. U tom .cer fajlu je **javni sertifikat** koji odgovara tvom **private_key.key** – zajedno čine jedan par.

---

## Kako se to sve povezuje

- **Private key** (iz Terminala) + **CSR** (iz Terminala) = jedan par.  
- Ti šalješ Apple-u samo **CSR**.  
- Apple ti daje **sertifikat** (.cer) koji „ide uz“ taj privatni ključ.  
- Za potpisivanje aplikacije računaru trebaju **oba**:  
  - **sertifikat** = Apple Distribution.cer  
  - **privatni ključ** = private_key.key  

Zato u koraku sa **.p12** stavljamo u jedan fajl:
- **certifikat** = **Apple Distribution.cer** (onaj koji si preuzela od Apple-a)
- **privatni ključ** = **private_key.key** (onaj koji si napravila u Terminalu)

Taj .p12 (npr. **MyChatEra.p12**) onda importuješ u Keychain – i cert i ključ budu u Keychain-u zajedno.

**Rezime:**  
- **Sertifikat** = onaj koji si napravila **u Apple Developer portalu** (preuzeti .cer).  
- **Privatni ključ** = onaj koji si napravila **u Terminalu** (private_key.key).  
U nastavku rada uvek kad kažem „sertifikat“, misli na **Apple Distribution.cer**; kad kažem „ključ“, na **private_key.key**.

---

# Nastavak rada – detaljni koraci (redom)

Pretpostavka: već imaš **private_key.key** i **Apple Distribution.cer** u **MyChatEra_Signing**, i **ubacila si MyChatEra.p12 u Keychain** (dupli klik na .p12, lozinka, login keychain). Ako to još nisi uradila, prvo završi korake iz **KEYCHAIN_IMPORT_P12.md**, pa onda nastavi odavde.

---

## KORAK 1: App Store provisioning profile (Apple Developer)

Ovo je **profil** koji kaže: „Aplikacija com.mychatera sme da se potpiše ovim Distribution sertifikatom za App Store.“

1. Otvori browser i idi na: **https://developer.apple.com/account**
2. Uloguj se Apple ID-om.
3. U levom meniju klikni **Profiles** (Provisioning Profiles).
4. Klikni **+** (plus) da kreiraš novi profil.
5. Izaberi **App Store** (pod Distribution) → **Continue**.
6. Na listi **App IDs** izaberi onaj sa **com.mychatera** → **Continue**.
   - Ako nema com.mychatera, prvo kreiraj: **Identifiers** → **+** → **App IDs** → App → Bundle ID **com.mychatera** → Register. Zatim se vrati na Profiles → **+** i ponovi od koraka 5.
7. Na listi **Certificates** izaberi **Apple Distribution** sertifikat (onaj koji si preuzela – trebalo bi da bude jedan ili prvi) → **Continue**.
8. U **Profile Name** unesi npr. **MyChatEraAI Distribution** → **Generate**.
9. Klikni **Download** i sačuvaj **.mobileprovision** fajl (npr. na Desktop ili u MyChatEra_Signing).
10. Na Mac-u **dupli klik** na taj **.mobileprovision** fajl da se instalira (Xcode/Mac će ga dodati u sistem). To je sve za profil.

---

## KORAK 2: Xcode – podešavanje potpisivanja

1. Otvori **Terminal** i ukucaj:
   ```bash
   cd /Users/m1/Desktop/myChatEra/ZaMariju
   open ios/Runner.xcworkspace
   ```
   Otvoriće se Xcode sa projektom **Runner** (koristi **Runner.xcworkspace**, ne .xcodeproj).

2. U **levom panelu** klikni na **Runner** (plava ikonica na vrhu – sam projekat).
3. U sredini, ispod **TARGETS**, izaberi target **Runner** (ne RunnerTests).
4. Gore izaberi karticu **Signing & Capabilities**.
5. Proveri:
   - **Automatically manage signing** – **isključeno** (Manual).
   - **Team** – izaberi svoj tim (npr. sa ID 522DMZ83DM).
   - **Provisioning Profile** – izaberi **MyChatEraAI Distribution** (ili tačno ime profila koje si dala u Koraku 1).
   - **Signing Certificate** – trebalo bi **Apple Distribution** (Xcode ga uzima iz Keychain-a gde si importovala .p12).
6. Ako Xcode prijavi grešku (npr. „No signing certificate“), proveri u **Keychain Access** da za „Apple Distribution“ / „MyChatEra Distribution“ vidiš i private key ispod (proširi cert strelicom). Ako nema, ponovo dupli klik na **MyChatEra.p12** i import u **login** keychain.
7. Sačuvaj projekat (**⌘ + S**) i možeš zatvoriti Xcode ako želiš.

---

## KORAK 3: Flutter – build IPA (Terminal)

1. Otvori **Terminal** (ako nije već otvoren).
2. Redom ukucaj i pritisni Enter nakon svake linije:

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

3. Sačekaj da se build završi (nekoliko minuta). Na kraju trebalo bi da piše da je uspešan.

---

## KORAK 4: Gde je IPA i šta s njim

- **Putanja do IPA:**  
  **Desktop → myChatEra → ZaMariju → build → ios → ipa → Runner.ipa**

- **Šta s njim:**  
  Ovaj **Runner.ipa** možeš uploadovati u App Store Connect (TestFlight / objava). Na Mac-u možeš koristiti aplikaciju **Transporter** (App Store): otvoriš Transporter, dodaješ **Runner.ipa** i šalješ.

---

## Rezime – šta je šta i šta si radila

| Šta              | Gde si ga napravila / dobila      | U čemu ga koristiš                          |
|------------------|------------------------------------|---------------------------------------------|
| private_key.key  | Terminal (OpenSSL)                 | U .p12 zajedno sa certom → Keychain         |
| CSR              | Terminal (OpenSSL)                 | Poslato Apple-u; posle više ne treba        |
| Apple Distribution.cer | Apple Developer (preuzeto)  | U .p12 zajedno sa keyem → Keychain         |
| MyChatEra.p12    | Terminal (openssl pkcs12)          | Import u Keychain (cert + key zajedno)      |
| .mobileprovision | Apple Developer (Profile)          | Dupli klik = instalacija na Mac, Xcode ga vidi |
| Runner.ipa       | Terminal (flutter build ipa)       | Upload u App Store (npr. Transporter)       |

Ako zapneš na bilo kom koraku, napiši koji broj koraka je u pitanju i šta tačno piše na ekranu (ili greška).
