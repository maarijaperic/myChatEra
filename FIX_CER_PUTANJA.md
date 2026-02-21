# Greška "No such file or directory" za Apple Distribution.cer

OpenSSL ne nalazi fajl jer ili nisi u pravom folderu, ili se .cer fajl zove drugačije / nalazi u Downloads.

---

## Korak 1: Proveri gde si i šta ima u folderu

U Terminalu ukucaj:

```bash
pwd
```

Trebalo bi da piše nešto kao: `/Users/m1/Desktop/MyChatEra_Signing`

Zatim:

```bash
ls -la
```

Proveri da li u listi vidiš neki **.cer** fajl. Može da se zove npr.:
- `Apple Distribution.cer`
- `Apple Distribution (522DMZ83DM).cer`
- `distribution.cer`

Zapiši **tačno ime** fajla (kako piše u listi).

---

## Korak 2a: Ako .cer NIJE u MyChatEra_Signing (npr. u Downloads)

Preuzeti sertifikat od Apple-a obično ode u **Downloads**. Proveri:

```bash
ls ~/Downloads/*.cer
```

Ako vidiš neki .cer fajl, kopiraj ga u MyChatEra_Signing. Zameni **TAČNO_IME_FAJLA** stvarnim imenom iz liste (npr. "Apple Distribution (522DMZ83DM).cer"):

```bash
cp ~/Downloads/"TAČNO_IME_FAJLA" ~/Desktop/MyChatEra_Signing/
```

Primer (ako se fajl zove "Apple Distribution (522DMZ83DM).cer"):

```bash
cp ~/Downloads/"Apple Distribution (522DMZ83DM).cer" ~/Desktop/MyChatEra_Signing/
```

Zatim uđi u folder i nastavi od Koraka 3.

---

## Korak 2b: Ako ne znaš tačno ime – listaj Downloads

```bash
ls ~/Downloads/ | grep -i cer
```

Ili samo:

```bash
ls ~/Downloads/
```

Nađi fajl koji ima **.cer** u imenu i koristi to ime u komandama ispod.

---

## Korak 3: Budi u pravom folderu

```bash
cd ~/Desktop/MyChatEra_Signing
```

---

## Korak 4: Konvertuj .cer u cert.pem (sa TAČNIM imenom fajla)

Apple često daje ime sa razmakom i zagradama. **Ime mora biti u navodnicima.**

Primer ako se fajl zove **Apple Distribution (522DMZ83DM).cer**:

```bash
openssl x509 -inform DER -in "Apple Distribution (522DMZ83DM).cer" -out cert.pem
```

Ako se zove samo **Apple Distribution.cer** i sada je u MyChatEra_Signing:

```bash
openssl x509 -inform DER -in "Apple Distribution.cer" -out cert.pem
```

Ako opet dobiješ grešku "Unable to load certificate", probaj bez DER (cert je već PEM):

```bash
openssl x509 -in "Apple Distribution (522DMZ83DM).cer" -out cert.pem
```

(Zameni ime fajla ako ti je drugačije.)

---

## Korak 5: Napravi .p12

Kad cert.pem postoji (nema greške), ukucaj:

```bash
openssl pkcs12 -export -out MyChatEra.p12 -inkey private_key.key -in cert.pem -name "MyChatEra Distribution"
```

Unesi lozinku za .p12 kad traži, zatim dupli klik na **MyChatEra.p12** u Finderu da ga importuješ u Keychain.
