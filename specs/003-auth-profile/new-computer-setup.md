# New Computer Setup

Use the existing repository directly. Do not create a new Flutter project
first.

## Install Tools

1. Install Git.
2. Install the Flutter SDK.
3. Install the platform toolchain you need.
4. Install VS Code or Android Studio.

## Get The Project

1. Clone the repository:

```bash
git clone https://github.com/Omar-Mosbah/bringly_app.git
cd bringly_app
```

2. Switch to the feature branch used for the current auth/profile work:

```bash
git checkout 003-auth-profile
git pull origin 003-auth-profile
```

## Prepare The Environment

1. Verify Flutter setup:

```bash
flutter doctor
```

2. Restore dependencies:

```bash
flutter pub get
```

3. Open the cloned `bringly_app` folder in your editor.

## Run The App

This project expects runtime configuration through Dart defines.

```bash
flutter run \
  --dart-define=SUPABASE_URL=YOUR_SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

Only use the public Supabase URL and publishable anon key. Do not add
service-role keys, private keys, passwords, or payment credentials to the app
or the repository.

## Validate The Setup

Run the standard checks after cloning:

```bash
flutter analyze
flutter test
```

## Continue The Current Feature Work

You can continue from the exact pause point already pushed to the repository.

Use these files as the current source of truth:

- `specs/003-auth-profile/spec.md`
- `specs/003-auth-profile/plan.md`
- `specs/003-auth-profile/tasks.md`

The current branch for this work is `003-auth-profile`.

## Notes

- Do not run `flutter create` inside this repository.
- Do not start from a zip file if you plan to continue development, commit, or
  push changes.
- Cloning the repository is the correct workflow for continuing the feature.