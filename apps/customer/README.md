# RepairMe customer app

Flutter app for RepairMe customers (Android first). English, Sinhala and Tamil.

## Run

```
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

Without Firebase settings the app uses the development login against an API
started with `AUTH_DEV_BYPASS=true`: any `+94 7x` number, code `123456`.

## Configuration (`--dart-define`)

| Name | Used for |
|---|---|
| `API_BASE_URL` | The RepairMe API (default `http://10.0.2.2:3000`, the host from the Android emulator) |
| `FIREBASE_PROJECT_ID`, `FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_SENDER_ID` | Real SMS sign-in. All empty = development login |
| `REPAIRME_SUPPORT_PHONE`, `REPAIRME_SUPPORT_EMAIL`, `REPAIRME_SUPPORT_CHAT` | Help & Support > Contact Support. A method is shown only when set |
| `REPAIRME_EMAIL`, `REPAIRME_PRIVACY_EMAIL`, `REPAIRME_PHONE`, `REPAIRME_WEBSITE`, `REPAIRME_ADDRESS` | About RepairMe, and the contact details inside the legal documents |
| `REPAIRME_INSTAGRAM_URL`, `REPAIRME_FACEBOOK_URL`, `REPAIRME_LINKEDIN_URL` | The Follow Us icons. Until set, tapping says the link isn't available yet |

The app version shown in Profile and About is read from `pubspec.yaml`.

## Languages

Text lives in `lib/l10n/app_en.arb`, `app_si.arb` and `app_ta.arb`. After editing
them run `flutter gen-l10n`. `python tool/arb_add.py strings.py` adds new strings
to all three files at once (see the script for the format).

Sinhala and Tamil use bundled Noto Sans fonts (`assets/fonts`, SIL Open Font
License). The legal documents come from the API in English only for now.

## Tests

```
flutter test
```

`test/layout_test.dart` renders every screen in all three languages at a small
phone width with the real fonts and fails on any overflow.
