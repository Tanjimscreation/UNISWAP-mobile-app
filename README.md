# UniSwap UTM — Sprint One

A campus marketplace **Android** app built with Flutter, where UTM students buy, sell and swap items with verified peers.

> Exclusive to **@utm.my** and **@graduate.utm.my** email holders.

---

## Sprint One — Feature Scope

### 1. Splash Screen
Animated logo + tagline ("Campus Marketplace · UTM"), routes to `/login` or `/profile` based on persisted session.

### 2. Login (UTM Gate)
- Email/password sign-in restricted to `@utm.my` / `@graduate.utm.my`
- Glassmorphism card on animated mesh-gradient background
- Google sign-in button (UI-only placeholder)
- Live regex validation of UTM email

### 3. Registration (2-Step Wizard)
- **Step 1 — UTM Gate:** verify campus email + create password
- **Step 2 — Identity:** full name, optional phone, faculty (8 UTM faculties: FC, FKM, FKE, FKA, FES, FABU, FS, AHIBS), campus (Skudai / KL), and Campus Safety & Fair Trade T&C

### 4. Profile / Portfolio
- Avatar, name, faculty, campus, trust score, member-since, verified badge
- Listings grid (real Unsplash imagery)
- Quick action: **List Item** bottom-sheet (title, price RM, condition, swap-only toggle)

### 5. Logout
- Disconnect from menu, clears `SharedPreferences` session

---

## Tech Stack

| Layer | Choice |
|---|---|
| Framework | Flutter (Dart `>=3.0.0 <4.0.0`) |
| Target | **Android** (`minSdk 21`, package `com.tanjimscreation.uniswap`) |
| State | `provider` |
| Storage | `shared_preferences` |
| Typography | `google_fonts` (Roboto / Inter) |

---

## Project Layout

```
lib/
├── main.dart                       # App entry & routes
├── theme/app_theme.dart            # Design tokens
├── models/
│   ├── user.dart                   # AppUser + demo data
│   └── product.dart                # Product, ItemCondition, mock catalog
├── providers/auth_provider.dart    # Auth, session, listings
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── registration_screen.dart
│   └── profile_screen.dart
└── widgets/
    ├── auth_shell.dart             # Mesh-gradient + glass primitives
    ├── item_card.dart              # Listing card
    └── list_item_sheet.dart        # Bottom-sheet to publish a listing
```

---

## Run on Android

### Prerequisites
- Flutter SDK 3.16+
- Android Studio + Android SDK (API 34)
- A device or emulator (API 21+)

### Steps
```bash
flutter pub get
flutter run            # debug build on attached device
flutter build apk      # release APK at build/app/outputs/flutter-apk/
```

---

## Tests

```bash
flutter test
```

Covers:
- UTM email regex (`AuthProvider.isValidUTMEmail`)
- App boots without crashing

---

## Roadmap (Sprint Two)

- [ ] Real auth backend (Firebase / Supabase)
- [ ] Cloud product listings & images upload
- [ ] In-app messaging between buyer & seller
- [ ] Push notifications
- [ ] Trade history & ratings
- [ ] Search, filters, categories

---

## License

MIT © Tanjim's Creation
