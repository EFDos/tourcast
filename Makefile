run:
	@flutter run --dart-define-from-file=env.json

test:
	@flutter test --dart-define-from-file=env.json

.PHONY: run test
