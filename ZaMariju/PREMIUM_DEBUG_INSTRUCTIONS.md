# 🔴 PREMIUM DEBUG - Kako pronaći debug poruke

## Problem
Konzola ima puno logova i teško je pronaći premium debug poruke.

## Rešenje: Filtriraj konzolu u Android Studio

### Metoda 1: Filter u Logcat-u

1. U Android Studio-u, otvori **Logcat** tab (dole)
2. U filter polju (gde piše "Show only selected application"), ukucaj:
   ```
   PREMIUM_DEBUG
   ```
3. Sada ćeš videti **SAMO** premium debug poruke! ✅

### Metoda 2: Filter po emoji-u

1. U Logcat filter polju, ukucaj:
   ```
   🔴
   ```
2. Sada ćeš videti sve poruke sa 🔴 emoji-jem

### Metoda 3: Filter po tekstu

1. U Logcat filter polju, ukucaj:
   ```
   PREMIUM
   ```
2. Sada ćeš videti sve premium-related poruke

---

## Šta tražiti u konzoli

Kada klikneš na "Unlock Premium", trebalo bi da vidiš:

```
🔴 PREMIUM_DEBUG: _handlePremiumTap - personalityType: TYPE A, mbtiType: INTJ
🔴 PREMIUM_DEBUG: Building _PremiumWrappedNavigator with insights
🔴 PREMIUM_DEBUG: _PremiumWrappedNavigator build - personalityType: TYPE A, mbtiType: INTJ, zodiacName: Virgo
```

Ako vidiš ove poruke, znači da se podaci prosleđuju pravilno!

---

## Ako ne vidiš poruke

1. Proveri da li je filter postavljen na `PREMIUM_DEBUG`
2. Proveri da li si kliknula na "Unlock Premium" dugme
3. Proveri da li je aplikacija pokrenuta u debug modu

---

## Brzi test

1. Otvori Logcat
2. Postavi filter: `PREMIUM_DEBUG`
3. Klikni na "Unlock Premium"
4. Trebalo bi da vidiš 2-3 poruke sa 🔴 emoji-jem

---

**Srećno! 🚀**

