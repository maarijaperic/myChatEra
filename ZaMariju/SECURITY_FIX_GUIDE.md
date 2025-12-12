# 🔒 Security Fix Guide - Google API Key Exposure

## ⚠️ HITNO: API Ključ je javno na GitHub-u

Tvoj Google API ključ je javno dostupan na GitHub-u. Treba hitno da:

1. **Napraviš repo privatnim**
2. **Regenerišeš API ključ**
3. **Dodaš API key restrictions**

---

## 📋 KORAK 1: Napravi Repo Privatnim na GitHub-u

### 1.1. Preko GitHub Web Interface

1. Idi na https://github.com/maarijaperic/myChatEra
2. Klikni na **Settings** (desno gore)
3. Scroll dole do **Danger Zone**
4. Klikni **Change visibility**
5. Izaberi **Make private**
6. Potvrdi unosom imena repozitorijuma

### 1.2. Preko GitHub CLI (ako imaš)

```bash
gh repo edit maarijaperic/myChatEra --visibility private
```

---

## 🔑 KORAK 2: Regeneriši API Ključ u Google Cloud Console

### 2.1. Otvori Google Cloud Console

1. Idi na https://console.cloud.google.com
2. Odaberi projekat **myChatEra** (id: mychatera)

### 2.2. Regeneriši API Ključ

1. U search box-u, ukucaj **"Credentials"** ili **"API keys"**
2. Idi na **APIs & Services** → **Credentials**
3. Pronađi ključ: `AIzaSyDRhPUPZ6pHBKdaqfQHuxxDZu5iKV7OfhY`
4. Klikni na ključ da ga otvoriš
5. Klikni **Regenerate key** (ili **Delete** pa kreiraj novi)
6. **KOPIRAJ NOVI KLJUČ** - nećeš ga moći da vidiš ponovo!

### 2.3. Ažuriraj GoogleService-Info.plist

1. Otvori `ios/Runner/GoogleService-Info.plist`
2. Zameni stari `API_KEY` sa novim ključem
3. Commit-uj izmene (repo je sada privatno, tako da je bezbedno)

---

## 🛡️ KORAK 3: Dodaj API Key Restrictions

### 3.1. Otvori API Key Settings

1. U Google Cloud Console → **Credentials**
2. Klikni na tvoj API ključ

### 3.2. Dodaj Application Restrictions

1. U sekciji **Application restrictions**, izaberi:
   - **iOS apps** (za iOS)
   - **Android apps** (za Android)
2. Dodaj Bundle ID / Package name:
   - iOS: `com.mychatera` (proveri u Xcode)
   - Android: `com.mychatera` (proveri u build.gradle)

### 3.3. Dodaj API Restrictions

1. U sekciji **API restrictions**, izaberi:
   - **Restrict key**
2. Izaberi samo potrebne API-je:
   - Firebase (ako koristiš)
   - Cloud Firestore API
   - Cloud Storage API (ako koristiš)

### 3.4. Sačuvaj

1. Klikni **Save**
2. Sačekaj nekoliko minuta da se promene primene

---

## 🔄 KORAK 4: Ažuriraj Lokalni Fajl

1. Otvori `ios/Runner/GoogleService-Info.plist`
2. Zameni stari API_KEY sa novim
3. Commit-uj izmene:

```bash
git add ios/Runner/GoogleService-Info.plist
git commit -m "Update GoogleService-Info.plist with new API key"
git push origin main
```

---

## ✅ Checklist

- [ ] Repo je sada privatno
- [ ] Stari API ključ je regenerisan/obrisan
- [ ] Novi API ključ je dodat u GoogleService-Info.plist
- [ ] API key restrictions su dodate (iOS/Android apps)
- [ ] API restrictions su dodate (samo potrebni API-ji)
- [ ] Izmene su commit-ovane i push-ovane

---

## ⚠️ VAŽNO

- **NIKADA** ne commit-uj API ključeve u javne repozitorijume
- Koristi environment variables ili secure storage
- Za produkciju, razmotri Firebase App Check za dodatnu sigurnost

