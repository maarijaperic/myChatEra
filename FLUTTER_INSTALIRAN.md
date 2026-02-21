# Flutter je instaliran

- **Flutter:** `/Users/m1/development/flutter` (dodato u `~/.zshrc` u PATH).
- **CocoaPods:** još nije instaliran – potrebno je da **jednom** u Terminalu ukucaš (i uneseš Mac lozinku kad traži):

```bash
sudo gem install cocoapods
```

Zatim:

```bash
source ~/.zshrc
cd /Users/m1/Desktop/myChatEra/ZaMariju
./build_ipa.sh
```

Skripta `build_ipa.sh` koristi Flutter iz `~/development/flutter/bin/flutter` čak i ako nisi pokrenula `source ~/.zshrc`, ali **pod** mora biti instaliran (gornja komanda).

**Rezime:** Jednom ukucaj `sudo gem install cocoapods`, pa onda `./build_ipa.sh`.
