# "No iOS App Store profiles matching MyChatEraAI Distribution2 are installed"

Export ne nalazi provisioning profile. Treba da ga **preuzmeš** od Apple-a i **instaliraš** na Mac (dupli klik na .mobileprovision).

---

## Korak 1: Preuzmi profil u Apple Developer

1. Otvori browser → **https://developer.apple.com/account**
2. Uloguj se Apple ID-om.
3. Levo: **Profiles** (Provisioning Profiles).
4. Na listi nađi profil **MyChatEraAI Distribution2** (ili slično ime).
5. Klikni na njega, pa **Download** (ili ikona za preuzimanje).
6. Sačuvaj **.mobileprovision** fajl (obično u Downloads).

---

## Korak 2: Instaliraj profil na Mac

1. U **Finderu** nađi preuzeti fajl (npr. **MyChatEraAI_Distribution2.mobileprovision**).
2. **Dupli klik** na njega.
3. Xcode / macOS će ga instalirati (može da iskoči kratka poruka). To je to – profil je sada na sistemu.

---

## Korak 3: Ponovo export (bez ponovnog builda)

Arhiva već postoji. Možeš da exportuješ u Xcode-u:

```bash
open /Users/m1/Desktop/myChatEra/ZaMariju/build/ios/archive/Runner.xcarchive
```

1. U Organizer-u: **Distribute App**.
2. **App Store Connect** → **Next**.
3. **Upload** ili **Export** (ako želiš samo IPA) → **Next**.
4. Izaberi **Manual** signing ako pita, pa izaberi **MyChatEraAI Distribution2** i **Apple Distribution**.
5. **Next** → **Distribute** ili **Export** i sačuvaj IPA.

Ili ponovo pokreni build (on će uraditi i export):

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
./build_ipa.sh
```

---

## Ako ne vidiš "MyChatEraAI Distribution2" u listi profila

- Proveri da li je profil **Active** (nije Expired/Revoked).
- Ako si ga preimenovala ili ima drugačije ime, u **ExportOptions.plist** u projektu mora da stoji **tačno** to ime (kao što piše u Developer portalu). Ako treba, napiši tačno ime profila pa možemo prilagoditi plist.
