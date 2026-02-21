# Keychain stalno traži šifru – kako da prestane

Codesign potpisuje desetine fajlova i za svaki pita Keychain. Treba **jednom** dozvoliti pristup private key-u da više ne pita.

---

## Korak 1: Prekini build (ako još traje)

U Terminalu pritisni **Ctrl + C** da prekineš build. Lozinku više ne unosi.

---

## Korak 2: Otvori Keychain Access

Spotlight (**⌘ + Space**) → ukucaj **Keychain Access** → Enter.

---

## Korak 3: Nađi private key

1. Levo izaberi **login** (ili **My Certificates** ako imaš).
2. U pretragu (gore desno) ukucaj **private** ili **Apple Distribution**.
3. Nađi **Apple Distribution** sertifikat i **klikni na strelicu** pored njega da se proširi.
4. Ispod će biti **private key** (npr. "private_key" ili ime koje si dala). **Klikni na taj private key** (ne na cert).

---

## Korak 4: Dozvoli pristup svim aplikacijama

1. **Dupli klik** na taj **private key** (ne na cert).
2. Otvoriće se prozor sa karticama: **Attributes**, **Access Control**, itd.
3. Izaberi karticu **Access Control** (ili **Kontrola pristupa**).
4. Izaberi opciju:
   - **"Allow all applications to access this item"** (Dozvoli svim aplikacijama pristup ovom predmetu)  
   **ili**
   - **"Confirm before allowing access"** isključi / ukloni sve iz liste i ostavi prazno, pa potvrdi.
5. Klikni **Save** (ili **Sačuvaj**).
6. Ako traži **lozinku** – unesi **Mac prijavnu lozinku** (samo ovaj put) i potvrdi.

Posle ovoga Keychain više ne bi trebalo da traži lozinku kad codesign potpisuje.

---

## Korak 5: Ponovo pokreni build

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
./build_ipa.sh
```

Build bi trebalo da prođe bez ponovnog traženja lozinke.

---

## Ako ne vidiš "Allow all applications"

- Neki macOS/Xcode prevodi: traži opciju tipa **"Dozvoli pristup svim aplikacijama"** ili **"Allow all apps"**.
- Ako postoji samo lista aplikacija: obriši sve iz liste (minus) i ostavi prazno, pa **Save** – to obično znači "ne pitaj za pristup".

---

## Rezime

1. Prekini build (Ctrl+C).
2. Keychain Access → **login** → nađi **private key** ispod Apple Distribution.
3. Dupli klik na **private key** → **Access Control** → **Allow all applications** (ili prazna lista) → **Save**.
4. Ponovo pokreni `./build_ipa.sh`.
