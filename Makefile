PUBSPEC=pubspec.yaml
VERSION_FILE=.new_version

.PHONY: all

format:
	@echo "Formatting Flutter..."
	@dart format lib
	@echo "Formatting Functions..."
	@cd functions && npm run lint -- --fix src
	@echo "Formatting completed."

distribute-app:
	@make --no-print-directory increment-version
	@make --no-print-directory build-apk
	@make --no-print-directory build-web
	@make --no-print-directory build-functions
	@make --no-print-directory deploy-apk
	@make --no-print-directory deploy-web
	@make --no-print-directory deploy-functions
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
	rm -f $(PUBSPEC).bak; \
	echo "Version updated successfully"

build-apk:
	@echo "Building APK..."
	@flutter build apk --dart-define-from-file=config/.env

deploy-apk:
	@APP_ID=$$(node -p "require('./firebase.json').flutter.platforms.android.default.appId"); \
	firebase appdistribution:distribute \
		build/app/outputs/flutter-apk/app-release.apk \
		--app "$$APP_ID" \
		--testers "f.laerciom@gmail.com"

build-functions:
	@echo "Building Firebase Functions..."
	@cd functions && npm install
	@cd functions && npm run lint
	@cd functions && npm run build

deploy-functions:
	@echo "Publishing Firebase Functions..."
	@firebase deploy --only functions

build-web:
	@echo "Building Flutter Web..."
	@flutter build web --dart-define-from-file=config/.env

deploy-web:
	@echo "Publishing Firebase Hosting..."
	@firebase deploy --only hosting

commit-message:
	@NEW_VERSION=$$(cat $(VERSION_FILE)); \
	echo "Commit message: [release] $$NEW_VERSION"; \
	rm -f $(VERSION_FILE)

store-private:
	-rm -rf private
	mkdir -p private/android/app
	mkdir -p private/config
	mkdir -p private/functions
	mkdir -p private/lib
	cp android/app/google-services.json private/android/app/
	cp android/app/key.jks private/android/app/
	cp config/.env private/config/
	cp functions/.env private/functions/
	cp lib/firebase_options.dart private/lib/
	cp firebase.json private/

restore-private:
	-rm android/app/google-services.json
	-rm android/app/key.jks
	-rm -rf config/
	-rm -rf functions/.env
	-rm lib/firebase_options.dart
	-rm firebase.json
	mkdir config/
	cp private/android/app/google-services.json android/app/
	cp private/android/app/key.jks android/app/
	cp private/config/.env config/
	cp private/functions/.env functions/
	cp private/lib/firebase_options.dart lib/
	cp private/firebase.json .
