# Fake Version Setup - App Store Review

## Overview

Ova funkcionalnost omogućava prebacivanje između **fake verzije** (file import login) i **real verzije** (web view login) putem backend flag-a. Fake verzija se koristi za App Store review dok real verzija ostaje netaknuta.

## Kako radi

1. **Real verzija (podrazumevano)**: Koristi web view login - korisnik se uloguje direktno preko ChatGPT
2. **Fake verzija**: Korisnik importuje `conversations.json` fajl - nema web view login

## Backend konfiguracija

U `backend/.env` fajlu, postavi:

```bash
# Za real verziju (web view login):
USE_FAKE_VERSION=false

# Za fake verziju (file import login):
USE_FAKE_VERSION=true
```

**Važno**: Nakon promene, redeploy backend (Google Cloud Run ili gde god je deployed).

## Flutter aplikacija

Aplikacija automatski proverava backend flag pri startu i:
- Ako je `USE_FAKE_VERSION=true` → koristi `FakeLoginScreen` (file import)
- Ako je `USE_FAKE_VERSION=false` ili greška → koristi `LoginScreen` (web view - ORIGINAL)

## Real verzija

**Real verzija ostaje potpuno netaknuta!**
- `screen_login.dart` - **NE MENJA SE**
- Web view login flow - **NE MENJA SE**
- Sve funkcionalnosti - **OSTAJU ISTE**

## Fake verzija

- `screen_fake_login.dart` - novi ekran za file import
- Koristi `file_picker` za odabir JSON fajla
- Parsira fajl i nastavlja sa istim flow-om kao real verzija
- Sve ostale funkcionalnosti su identične

## Workflow za App Store

1. **Pre review**:
   - Postavi `USE_FAKE_VERSION=true` u backend
   - Redeploy backend
   - Submit app sa fake verzijom

2. **Nakon odobrenja**:
   - Postavi `USE_FAKE_VERSION=false` u backend
   - Redeploy backend
   - App automatski prelazi na real verziju

## Endpoint

Backend endpoint: `GET /api/app-version`

Response:
```json
{
  "useFakeVersion": true
}
```

## Fajlovi koji su dodati/modifikovani

### Dodati:
- `lib/services/app_version_service.dart` - proverava backend flag
- `lib/screen_fake_login.dart` - ekran za file import
- `backend/main.py` - dodat `/api/app-version` endpoint

### Modifikovani:
- `lib/screen_welcome.dart` - proverava flag i rutira na fake/real login
- `lib/main.dart` - inicijalizuje AppVersionService
- `pubspec.yaml` - dodato `file_picker` dependency
- `backend/env.example` - dodata `USE_FAKE_VERSION` varijabla

### Netaknuti (REAL VERZIJA):
- `lib/screen_login.dart` - **NEMA IZMENA**
- Svi ostali fajlovi - **NEMA IZMENA**







