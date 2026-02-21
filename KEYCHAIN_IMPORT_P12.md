# Kako da ubaciš private key u Keychain – preko .p12 fajla

Keychain Access ne voli da importuje samo **.key** fajl. Zato pravimo **.p12** fajl (sertifikat + privatni ključ u jednom), pa ga importuješ – Keychain to prihvata bez problema.

---

## Šta ti treba (već imaš)

- **private_key.key** – u **Desktop → MyChatEra_Signing**
- **Apple Distribution.cer** – preuzeti iz Apple portala, takođe u **MyChatEra_Signing**

(Oba fajla moraju biti u istom folderu **MyChatEra_Signing** na Desktopu.)

---

## Korak 1: Otvori Terminal

- **⌘ + Space** → ukucaj **Terminal** → Enter.

---

## Korak 2: Idi u folder gde su fajlovi

Ukucaj i pritisni Enter:

```bash
cd ~/Desktop/MyChatEra_Signing
```

---

## Korak 3: Konvertuj .cer u .pem (ako treba)

Apple-ov **.cer** fajl je obično u DER formatu. Prvo ga pretvaramo u PEM:

```bash
openssl x509 -inform DER -in "Apple Distribution.cer" -out cert.pem
```

**Ako dobiješ grešku** tipa „Unable to load certificate“, probaj bez `-inform DER` (znači da je već PEM):

```bash
openssl x509 -in "Apple Distribution.cer" -out cert.pem
```

Nakon ovoga u folderu **MyChatEra_Signing** trebalo bi da imaš **cert.pem**.

---

## Korak 4: Napravi .p12 fajl (sertifikat + private key)

Ukucaj (možeš kopirati ceo red):

```bash
openssl pkcs12 -export -out MyChatEra.p12 -inkey private_key.key -in cert.pem -name "MyChatEra Distribution"
```

Pritisni **Enter**.

- Terminal će tražiti **Export Password** (lozinka za .p12 fajl).
- **Unesi neku lozinku** (npr. `mychatera123`) i **zapamti je** – trebaće ti kad budeš importovala .p12 u Keychain.
- Zatim je ponovo unesi kad traži **Verifying - Enter Export Password**.

**Napomena:** Kad kucaš lozinku, na ekranu se ništa ne prikazuje (nema zvezdica) – to je normalno, samo ukucaj i Enter.

---

## Korak 5: Proveri da postoji MyChatEra.p12

U Terminalu:

```bash
ls -la MyChatEra.p12
```

Trebalo bi da vidiš fajl. Ako ga ima, nastavi.

---

## Korak 6: Import .p12 u Keychain

1. Otvori **Finder** → **Desktop** → **MyChatEra_Signing**.
2. Nađi fajl **MyChatEra.p12**.
3. **Dupli klik** na **MyChatEra.p12**.
4. Iskočiće prozor **Keychain Access** (ili „Add Keychain“):
   - **Keychain:** ostavi **login** (predloženo).
   - Klikni **Add** ili **OK**.
5. Tražiće **lozinku** za .p12 – unesi onu koju si stavila u Koraku 4 (npr. `mychatera123`).
6. Možda traži i **Mac prijavnu lozinku** (za keychain „login“) – unesi svoju Mac lozinku.
7. Klikni **OK** / **Allow** / **Always Allow** ako pita za dozvole.

Sada su **sertifikat i private key** u Keychain-u zajedno. Ne moraš više da importuješ **private_key.key** posebno.

---

## Korak 7: Provera u Keychain Access-u

1. Otvori **Keychain Access** (ako već nije).
2. Levo izaberi **login** (ili „login“ keychain).
3. U listi nađi **MyChatEra Distribution** (ili „Apple Distribution“) – klikni na strelicu pored da proširiš.
4. Ispod trebalo bi da vidiš i **private key** (npr. „private_key“). To znači da je sve u redu.

---

## Ako .cer fajl ima drugačije ime

Ako ti se .cer fajl zove npr. **Apple Distribution (522DMZ83DM).cer** ili **distribution.cer**, u Koraku 3 zameni ime u komandi:

```bash
openssl x509 -inform DER -in "Apple Distribution (522DMZ83DM).cer" -out cert.pem
```

(koristi tačno ono ime kako piše u Finderu, između navodnika.)

---

## Šta dalje

Nastavi sa **SLEDECI_KORACI_POSLE_CSR.md** od **Deo C** (Provisioning profile), pa **Deo D** (Xcode), pa **Deo E** (Flutter build). Deo B (import samo private key) više ne treba – zamenjen je ovim .p12 importom.
