# Instalacija provisioning profila – folder ne postoji

Dupli klik na .mobileprovision ponekad ne kreira folder. Evo kako da ga **ručno** instaliraš.

---

## Korak 1: Kreiraj folder i kopiraj profil

U **Terminalu** ukucaj redom (zameni **IME_FAJLA.mobileprovision** stvarnim imenom fajla iz Downloads):

```bash
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles/
```

Zatim kopiraj profil (primer – ako se fajl zove drugačije, zameni):

```bash
cp ~/Downloads/MyChatEraAI_Distribution2.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
```

Ako ne znaš tačno ime fajla, u Terminalu ukucaj:

```bash
ls ~/Downloads/*.mobileprovision
```

Kopiraj ceo fajl (npr. nešto kao `abc123.mobileprovision`):

```bash
cp ~/Downloads/*.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
```

---

## Korak 2: Proveri da je tu

```bash
ls ~/Library/MobileDevice/Provisioning\ Profiles/
```

Trebalo bi da vidiš bar jedan .mobileprovision fajl.

---

## Korak 3: Ponovo export

Otvori arhivu i uradi Distribute App (Export), ili pokreni build:

```bash
open /Users/m1/Desktop/myChatEra/ZaMariju/build/ios/archive/Runner.xcarchive
```

Ili:

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
./build_ipa.sh
```

---

## Alternativa: instalacija preko Xcode-a

1. Otvori **Xcode**.
2. **Xcode** → **Settings** (ili Preferences) → **Accounts**.
3. Izaberi svoj **Apple ID** → **Download Manual Profiles** (ili **Manage Certificates** / profili).
4. Ili u **Finderu**: prevuci **.mobileprovision** fajl **na Xcode ikonu** (u Dock-u) – Xcode će ga instalirati.

Zatim ponovo korak 3 (export ili build).
