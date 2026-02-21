# Kako da isprobaš nove proizvode (pretplate) – Simulator i TestFlight

Imaš novu verziju (1.0.1, build 1) i nove proizvode u App Store Connectu. **Prvo** testiraj u Simulatoru sa StoreKit fajlom, **pa onda** TestFlight na pravom telefonu.

---

## Koraci: StoreKit u Simulatoru (prvo ovo)

Ovim proveravaš da aplikacija traži ispravne product ID-ove i da ekran pretplate radi. Nema pravog App Store / RevenueCat poziva – sve je lokalno u Simulatoru. Kad ovo prođe, prelaziš na TestFlight.

U projektu već postoji **Products.storekit** sa proizvodima:
- `one_time_purchase_v2`
- `monthly_subscription_v2`
- `yearly_subscription_v2`

---

### 1. Otvori projekat u Xcode-u

**Šta je šta (da ne bude zbunjujuće):**

U folderu **ZaMariju → ios** imaš više stvari koje zovu "Runner":
- **Runner** (plava ikonica, **folder**) = samo folder sa fajlovima, na njega ne klikćeš da otvoriš projekat
- **Runner** (ikonica Xcode projekta) = može biti **Runner.xcodeproj** ili **Runner.xcworkspace**

Za ovaj projekat treba da otvoriš **workspace** (`.xcworkspace`), ne običan projekat (`.xcodeproj`), jer aplikacija koristi biblioteke (CocoaPods) koje se učitavaju samo kad otvoriš workspace.

**Najlakše – uradi ovo:**

1. Otvori **Terminal** (Finder → Applications → Utilities → Terminal, ili pretraživač → Terminal).
2. Ukucaj tačno ovo (možeš kopirati) i pritisni Enter:
   ```bash
   open ~/Desktop/myChatEra/ZaMariju/ios/Runner.xcworkspace
   ```
3. Otvoriće se **Xcode** sa tvojim projektom. To je to – otvorila si pravi fajl.

**Ako hoćeš iz Finder-a:**

1. Idi: **Desktop → myChatEra → ZaMariju → ios**.
2. Ako vidiš samo "Runner" bez nastavka, uključi prikaz ekstenzija: **Finder → Settings (ili Preferences) → Advanced** → uključi **"Show all filename extensions"**. Tada ćeš videti **Runner.xcworkspace** i **Runner.xcodeproj**.
3. Dupli klik na **Runner.xcworkspace** (ne na .xcodeproj).

---

### 2. Proveri da Scheme koristi StoreKit fajl

1. U meniju: **Product → Scheme → Edit Scheme** (ili tipka **⌘ &lt;**).
2. Levo izaberi **Run**.
3. Gore izaberi tab **Options**.
4. Kod **StoreKit Configuration** izaberi iz padajuće liste: **Products.storekit**.
5. Klikni **Close**.

Ako **Products.storekit** nije u listi, u levom panelu u Xcode-u nađi **Products.storekit** (obično u root-u, pored **Runner** foldera). Ako ga nema, vidi „Ako fajl ne postoji“ na dnu ove sekcije.

---

### 3. Pokreni emulator i build iz Terminala

Otvori **Terminal** i uradi redom (možeš kopirati blok):

```bash
# Uđi u folder projekta
cd ~/Desktop/myChatEra/ZaMariju

# Pokreni iPhone 16 simulator (ako već ne radi)
xcrun simctl boot "iPhone 16"
open -a Simulator

# Sačekaj par sekundi da se Simulator podigne, pa pokreni app
flutter run -d "iPhone 16"
```

Ako ne prepozna uređaj, prvo vidi listu: `flutter devices` — pa za **-d** stavi tačan naziv (npr. `iPhone 16 Pro`).

**Važno za StoreKit:** Kad pokreneš app preko **flutter run**, StoreKit fajl (Products.storekit) ponekad se ne uključi, jer je vezan za Xcode scheme. Ako u aplikaciji ne izbaci dijalog za kupovinu ili kaže „product not found“, pokreni umesto toga iz **Xcode-a**: izaberi **iPhone 16** u toolbar-u i pritisni **Run (▶)** ili **⌘R**. Tada će se sigurno koristiti Products.storekit.

---

### 4. Ili pokreni samo iz Xcode-a (najsigurnije za StoreKit)

- Gore u Xcode toolbar-u izaberi **iPhone 16** (ili drugi simulator).
- Klikni **Run** (▶) ili **⌘R**.
- Sačekaj da se Simulator podigne i da se app instalira i pokrene.

---

### 5. Isprobaj „kupovinu“ u aplikaciji

1. U aplikaciji otvori ekran gde se bira pretplata / kupovina (Premium, Subscribe, itd.).
2. Izaberi jedan od proizvoda (npr. One-Time, Monthly ili Yearly).
3. Klikni dugme za kupovinu.
4. U Simulatoru bi trebalo da se pojavi StoreKit dijalog za potvrdu (lokalno, bez pravog novca). Potvrdi.
5. Proveri da aplikacija prikaže uspeh (npr. da si „premium“ ili da se ekran zatvori kako treba).

Ako vidiš grešku tipa „product not found“ ili slično, proveri u **Products.storekit** da product ID-ovi budu **tačno** kao u listi na početku ove sekcije (bez razmaka, mala slova, sa `_v2`).

---

### 6. (Opciono) Provera / izmena Products.storekit

- U levom panelu u Xcode-u klikni na **Products.storekit**.
- U editoru vidiš proizvode. Product ID-ovi moraju biti:
  - `one_time_purchase_v2` (tip: Non-Consumable)
  - `monthly_subscription_v2` (Recurring Subscription, P1M)
  - `yearly_subscription_v2` (Recurring Subscription, P1Y)
- Ako nešto menjaš, sačuvaj (**⌘S**), pa ponovo **Run** u Simulatoru.

---

**Ako Products.storekit ne postoji u projektu**

1. **File → New → File…**
2. Izaberi **StoreKit Configuration File** → Next.
3. Ime: **Products**, lokacija: **ios** folder (isti gde je Runner) → Create.
4. Dupli klik na **Products.storekit**, pa **+** da dodaš proizvode sa ID-ovima kao gore (one_time_purchase_v2, monthly_subscription_v2, yearly_subscription_v2).
5. Zatim **Product → Scheme → Edit Scheme → Run → Options → StoreKit Configuration** → izaberi **Products.storekit**.

Kad Simulator test prođe, prelazi na TestFlight korake ispod.

---

## Sledeće: TestFlight + Sandbox (prava kupovina na telefonu)

Ovde se koristi **pravi** build (npr. 1.1), **Sandbox** Apple ID i TestFlight. Tako vidiš da li novi proizvodi rade (App Store Connect + RevenueCat).

---

### Da li moraš „Add for Review“ da bi isprobala?

**Ne.** Možeš **prvo da isprobaš**, pa tek kasnije da pošalješ na review.

- **Internal testeri** (ti i ljudi iz tvog App Store Connect tima):  
  **Ne treba review.** Dodaš build u **Internal Testing** grupu i odmah možeš da testiraš (čim build postane „Ready to Test“). Niko od Applea ne gleda build za Internal.

- **External testeri** (prijatelji, korisnici po email-u ili preko public linka):  
  **Prvi put** za tu grupu Apple traži **Beta App Review** (poseban TestFlight review). Pošalješ build na „Submit for Review“ za tu External grupu; kad odobre, link/email testeri mogu da instaliraju. Kasnije možeš da dodaješ **nove** buildove u istu External grupu bez novog reviewa (neko vreme / dok ne promeniš nešto bitno).

**Rezime:** Da bi **ti** isprobala verziju 1.1 u TestFlightu: koristi **Internal Testing**, dodaš build u Internal grupu, **ne šalješ** na review – odmah možeš da instaliraš preko TestFlight app i da testiraš (sa Sandbox Apple ID-om za kupovinu).

---

### Ko može da testira, a ko ne?

| Tip testera | Ko su | Review? | Kada mogu da testiraju? |
|-------------|--------|--------|--------------------------|
| **Internal** | Samo ljudi koji imaju ulogu u App Store Connect (Admin, App Manager, Developer, Marketing) – max 100 | **Ne** | Odmah kad dodaš build u Internal grupu |
| **External** | Bilo ko – dodaješ po email-u ili preko public linka | **Da**, prvi put za tu grupu (Beta App Review) | Kad Apple odobri Beta App Review za tu grupu |

Ako si **sama** u timu, ti si Internal tester – dodaš build u Internal Testing i sebi pošalješ link (ili instaliraš iz TestFlight app ako si već u grupi), i možeš da testiraš bez ikakvog reviewa.

---

### Korak 1: Provera da je build u TestFlightu

1. Uloguj se na **App Store Connect**: https://appstoreconnect.apple.com
2. **My Apps** → aplikacija **MyChatEra AI**
3. Tab **TestFlight**
4. Levo: **iOS** → **Builds** (ili **Internal Testing** / **External Testing**)
5. Proveri da se vidi tvoj build (npr. **1.1 (1)** ili **1.0.1 (1)**) i da je status **Ready to Test** (ili **Processing** pa sačekaj da postane Ready).

Ako builda nema ili je u statusu „Missing compliance“ itd., prvo to reši (npr. odgovori na pitanja o export compliance, itd.).

### Korak 2: Dodavanje builda u grupu za testiranje

1. U TestFlight-u, levo: **Internal Testing** ili **External Testing**
2. Ako koristiš **Internal Testing**:
   - Klikni na grupu (npr. „Internal Testers“) ili kreiraj novu.
   - U sekciji **Builds** klikni **+** i izaberi svoj build (npr. 1.1 (1)). Sačuvaj.
3. Ako koristiš **External Testing**:
   - Izaberi grupu (ili kreiraj novu).
   - U **Builds** dodaj build. Prvi put će tražiti **Submit for Review** (Beta App Review) za tu grupu.

### Korak 3: Kako doći do TestFlight linka

- **Internal Testing:**  
  U grupi vidiš **Enable Public Link** (ili **Share**). Ako uključiš link, dobijaš **Public Link** koji možeš kopirati i poslati sebi (ili testerima). Testeri otvore link na **iPhone-u** (ne na Mac-u); moraju biti ulogovani sa Apple ID-om da vide „Accept“ i instalaciju.

- **External Testing:**  
  Dodaješ testere po email-u ili omogućiš **Public Link** (ako je dostupan za tu grupu). Link izgleda otprilike:  
  `https://testflight.apple.com/join/XXXXXX`

Ako **ne vidiš** opciju za link:
- Proveri da je build **1.0.1 (1)** zaista dodat toj TestFlight grupi.
- Za **External** grupu ponekad mora prvo da se pošalje build na TestFlight review; dok ne odobre, link može biti neaktivan.
- Internal link obično postoji odmah kada dodaš build u Internal grupu i uključiš „Enable Public Link“.

### Korak 4: Sandbox Apple ID (za „kupovinu“ u TestFlight buildu)

Da ne trošiš pravi novac, koristiš **Sandbox** nalog:

1. Na Mac-u ili iPhone-u: **Settings → App Store → Sandbox Account** (ili na appleid.apple.com → **Sandbox** tester).
2. Ili: https://appstoreconnect.apple.com → **Users and Access** → **Sandbox** → **Testers** → kreiraj **Sandbox Apple ID** (npr. test@mydomain.com).
3. Na **iPhone-u** gde ćeš instalirati TestFlight build: **Settings → App Store → scroll dole → Sandbox Account** → uloguj se sa tim Sandbox Apple ID-om.
4. Otvori **TestFlight** aplikaciju, instaliraj **MyChatEra AI** (build 1.0.1). Kad u aplikaciji dođeš do kupovine, StoreKit će koristiti Sandbox – ne naplaćuje se.

### Korak 5: Provera novih proizvoda

1. Na telefonu ulogovan **Sandbox** nalog (Settings → App Store → Sandbox Account).
2. TestFlight → **MyChatEra AI** → **Install** (ako već nije).
3. Otvori aplikaciju → ekran pretplata → izaberi novi proizvod (one-time / monthly / yearly) i probaj „kupovinu“.
4. Trebalo bi da vidiš Sandbox dijalog („Sandbox“ negde u poruci) i da se pretplata označi kao uspešna bez naplate.

Ako nešto ne radi (npr. „Product not available“, „Needs developer action“):
- U **App Store Connect → Your App → In-App Purchases** proveri da su novi proizvodi u statusu **Ready to Submit** i da su povezani sa pravom verzijom (1.0.1).
- U **RevenueCat** dashboardu proveri da su ti isti product ID-ovi (one_time_purchase_v2, monthly_subscription_v2, yearly_subscription_v2) dodati u Products i u Offerings, i da je entitlement **premium** povezan sa tim proizvodima.

---

## Zašto „ne možeš da namestiš link“ za TestFlight

Česte cause:

1. **Build još nije Ready to Test** – sačekaj da processing završi (može 10–30 min).
2. **Build nije dodat u nijednu TestFlight grupu** – u TestFlight → Internal/External → grupa → Builds → **+** i izaberi 1.0.1 (1).
3. **External grupa** – prvi put traži **Submit for Review** za TestFlight; dok se to ne odobri, link može biti neaktivan. Internal link radi bez reviewa.
4. **Link se otvara na pogrešnom uređaju** – TestFlight link treba otvoriti na **iPhone-u** (ili iPad-u), ne na Mac-u, i biti ulogovan sa Apple ID-om.

---

## Rezime

| Gde testiraš | Šta proveravaš | Kako |
|--------------|----------------|------|
| **Simulator** | UI i tok kupovine, ispravan product ID u kodu | Xcode → Run na Simulator, StoreKit Configuration = Products.storekit, proizvodi u .storekit sa one_time_purchase_v2, monthly_subscription_v2, yearly_subscription_v2 |
| **TestFlight** | Da li novi proizvodi zaista rade (App Store + RevenueCat) | Build 1.0.1 (1) u TestFlight grupi, Sandbox Apple ID na iPhone-u, instalacija iz TestFlight app, kupovina u aplikaciji |

Prvo isprobaj Simulator (StoreKit) da vidiš da li app uopšte traži nove ID-ove; zatim TestFlight + Sandbox da potvrdiš da sve radi u „pravom“ okruženju.
