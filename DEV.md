# Development Notes

Do not commit `secrets.env` (it is gitignored) or any API keys.

IntelliJ/Android Studio Run Configuration (Additional run args):
```
--dart-define-from-file=secrets.env
```

CLI run:
```
flutter run --dart-define-from-file=secrets.env
```

CLI build:
```
flutter build apk --release --dart-define-from-file=secrets.env
```

Generate json_serializable models:
``` shell
dart run build_runner build --delete-conflicting-outputs
```

Watch mode:
```
dart run build_runner watch --delete-conflicting-outputs
```
