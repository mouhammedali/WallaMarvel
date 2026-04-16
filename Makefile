# WallaMarvel Development Makefile
# Usage: make <target>

SCHEME_APP = WallaMarvel
SCHEME_TESTS = WallaMarvelTests
SCHEME_UITESTS = WallaMarvelUITests
DESTINATION = platform=iOS Simulator,name=iPhone 16 Pro,OS=18.5
PROJECT = WallaMarvel.xcodeproj

.PHONY: all generate build test test-unit test-ui test-modules lint clean help record-snapshots

# Default: generate project and build
all: generate build

# Generate Xcode project from project.yml
generate:
	@echo "Generating Xcode project..."
	@xcodegen generate

# Build the app
build: generate
	@echo "Building $(SCHEME_APP)..."
	@xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME_APP) \
		-destination '$(DESTINATION)' \
		-quiet build

# Run all tests (modules + unit + UI)
test: test-modules test-unit test-ui

# Run SPM module tests
test-modules: test-networking test-domain test-data test-designsystem

test-networking:
	@echo "Testing Networking module..."
	@cd Modules/Networking && swift test --quiet

test-domain:
	@echo "Testing Domain module..."
	@cd Modules/Domain && swift test --quiet

test-data:
	@echo "Testing Data module..."
	@cd Modules/Data && swift test --quiet

test-designsystem:
	@echo "Testing DesignSystem module..."
	@cd Modules/DesignSystem && swift test --quiet

# Run unit tests
test-unit:
	@echo "Running unit tests..."
	@xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME_TESTS) \
		-destination '$(DESTINATION)' \
		-resultBundlePath .build/unit-tests.xcresult \
		test 2>&1 | xcbeautify || xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME_TESTS) \
		-destination '$(DESTINATION)' \
		test

# Run UI tests
test-ui:
	@echo "Running UI tests..."
	@xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME_UITESTS) \
		-destination '$(DESTINATION)' \
		-resultBundlePath .build/ui-tests.xcresult \
		test 2>&1 | xcbeautify || xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME_UITESTS) \
		-destination '$(DESTINATION)' \
		test

# Record snapshot reference images
record-snapshots:
	@echo "Recording DesignSystem snapshots..."
	@cd Modules/DesignSystem && SNAPSHOT_TESTING_RECORD=true swift test

# Run SwiftLint
lint:
	@echo "Running SwiftLint..."
	@swiftlint lint --config .swiftlint.yml

# Fix auto-correctable SwiftLint violations
lint-fix:
	@echo "Auto-fixing SwiftLint violations..."
	@swiftlint lint --fix --config .swiftlint.yml

# Clean build artifacts
clean:
	@echo "Cleaning..."
	@xcodebuild -project $(PROJECT) -scheme $(SCHEME_APP) clean 2>/dev/null || true
	@rm -rf .build DerivedData
	@for dir in Modules/*/; do rm -rf "$$dir/.build"; done

# Show help
help:
	@echo "Available targets:"
	@echo "  make generate          - Generate Xcode project from project.yml"
	@echo "  make build             - Build the app (generates project first)"
	@echo "  make test              - Run all tests (modules + unit + UI)"
	@echo "  make test-modules      - Run SPM module tests only"
	@echo "  make test-unit         - Run unit tests only"
	@echo "  make test-ui           - Run UI tests only"
	@echo "  make record-snapshots  - Record DesignSystem snapshot reference images"
	@echo "  make lint              - Run SwiftLint analysis"
	@echo "  make lint-fix          - Auto-fix SwiftLint violations"
	@echo "  make clean             - Clean build artifacts"
	@echo "  make help              - Show this help"
