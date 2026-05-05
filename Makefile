run:
	flutter run --dart-define-from-file=.env.json

build-apk:
	flutter build apk --dart-define-from-file=.env.json

build-ios:
	flutter build ios --dart-define-from-file=.env.json
