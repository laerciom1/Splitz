PUBSPEC=pubspec.yaml
VERSION_FILE=.new_version

.PHONY: distribute-app increment-version build-apk upload-apk commit-message

distribute-app:
	@make --no-print-directory increment-version
	@make --no-print-directory build-apk
	@make --no-print-directory upload-apk
	@make --no-print-directory commit-message

increment-version:
	@VERSION=$$(grep '^version:' $(PUBSPEC) | awk '{print $$2}'); \
	echo "Current version: $$VERSION"; \
	echo "Choose 1 = MAJOR, 2 = MINOR or 3 = PATCH:"; \
	read PART; \
	MAJOR=$$(echo $$VERSION | cut -d. -f1); \
	MINOR=$$(echo $$VERSION | cut -d. -f2); \
	PATCH=$$(echo $$VERSION | cut -d. -f3); \
	case $$PART in \
		1) NEW_VERSION="$$(($$MAJOR + 1)).0.0";; \
		2) NEW_VERSION="$$MAJOR.$$(($$MINOR + 1)).0";; \
		3) NEW_VERSION="$$MAJOR.$$MINOR.$$(($$PATCH + 1))";; \
		*) echo "Invalid option: $$PART (available options are M = major, m = minor or p = patch)" && exit 1;; \
	esac; \
	echo "New version: $$NEW_VERSION"; \
	echo $$NEW_VERSION > $(VERSION_FILE); \
	sed -i.bak "s/^version:.*/version: $$NEW_VERSION/" $(PUBSPEC); \
	-rm -f $(PUBSPEC).bak; \
	echo "Version updated successfully"

build-apk:
	@echo "Building APK..."
	@flutter build apk --dart-define-from-file=config/.env

upload-apk:
	@APP_ID=$$(jq -r '.flutter.platforms.android.default.appId' firebase.json); \
	firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk --app $$APP_ID --testers "f.laerciom@gmail.com"

commit-message:
	@NEW_VERSION=$$(cat $(VERSION_FILE)); \
	echo "Commit message: [release] $$NEW_VERSION"; \
	-rm -f $(VERSION_FILE)

store-private:
	-rm -rf private
	mkdir -p private/config
	mkdir -p private/lib
	mkdir -p private/android/app
	mkdir -p private/ios/Runner
	cp firebase.json private/
	cp config/.env private/config/
	cp lib/firebase_options.dart private/lib/
	cp lib/gsheets_credentials.dart private/lib/
	cp android/app/google-services.json private/android/app/
	cp android/app/key.jks private/android/app/
	cp ios/Runner/GoogleService-Info.plist private/ios/Runner/
	cp ios/Runner/Info.plist private/ios/Runner/

restore-private:
	-rm firebase.json
	-rm -rf config/
	-rm lib/firebase_options.dart
	-rm lib/gsheets_credentials.dart
	-rm android/app/google-services.json
	-rm android/app/key.jks
	-rm ios/Runner/GoogleService-Info.plist
	-rm ios/Runner/Info.plist
	mkdir config/
	cp private/firebase.json .
	cp private/config/.env config/
	cp private/lib/firebase_options.dart lib/
	cp private/lib/gsheets_credentials.dart lib/
	cp private/android/app/google-services.json android/app/
	cp private/android/app/key.jks android/app/
	cp private/ios/Runner/GoogleService-Info.plist ios/Runner/
	cp private/ios/Runner/Info.plist ios/Runner/