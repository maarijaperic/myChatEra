# Kako da središ CocoaPods (pod: command not found)

Sistemski Ruby (2.6) je prestar. **Najlakše:** instaliraj CocoaPods preko **Homebrew** – ne diraš Ruby.

---

## Korak 1: Proveri da li imaš Homebrew

U Terminalu ukucaj:

```bash
which brew
```

- Ako ispiše putanju (npr. `/opt/homebrew/bin/brew` ili `/usr/local/bin/brew`) – imaš Homebrew, idi na **Korak 2**.
- Ako piše `brew not found` – prvo instaliraj Homebrew (**Korak 1b**).

---

## Korak 1b: Instalacija Homebrew (samo ako nemaš)

Kopiraj ceo red i pritisni Enter (tražiće Mac lozinku):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Na kraju instalacije **pročitaj poruku** – na Apple Silicon Mac-u obično kaže da dodaš u PATH, npr.:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Ukucaj te dve linije ako ih prikaže (ili slične). Zatim zatvori i otvori novi Terminal.

---

## Korak 2: Instaliraj CocoaPods preko Homebrew

```bash
brew install cocoapods
```

Sačekaj da se završi. Zatim proveri:

```bash
which pod
pod --version
```

Ako vidiš putanju i verziju – **pod** radi.

---

## Korak 3: Ponovo pokreni build

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
./build_ipa.sh
```

---

## Ako i dalje kaže "pod: command not found"

Na Apple Silicon (M1/M2/M3) Homebrew je u `/opt/homebrew/bin`. Dodaj u PATH u `.zshrc`:

```bash
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Zatim ponovo:

```bash
cd /Users/m1/Desktop/myChatEra/ZaMariju
./build_ipa.sh
```

---

**Rezime:** `brew install cocoapods` (ako nemaš brew, prvo instaliraj Homebrew), pa `./build_ipa.sh`.
