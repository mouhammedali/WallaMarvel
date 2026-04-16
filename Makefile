# WallaMarvel Development Makefile
# Usage: make <target>

SCHEME_APP = WallaMarvel
DESTINATION = platform=iOS Simulator,name=iPhone 16 Pro,OS=18.5
PROJECT = WallaMarvel.xcodeproj

.PHONY: all generate build test test-all test-unit test-ui test-modules lint clean help record-snapshots

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

# Run all tests at once via Xcode Test Plan (single invocation)
test-all:
	@echo "Running all tests via test plan..."
	@rm -rf .build/all-tests.xcresult
	@xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME_APP) \
		-testPlan WallaMarvel \
		-destination '$(DESTINATION)' \
		-resultBundlePath .build/all-tests.xcresult \
		test 2>&1 | xcbeautify || xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME_APP) \
		-testPlan WallaMarvel \
		-destination '$(DESTINATION)' \
		test

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

# Run unit tests only (WallaMarvelTests + module tests via test plan)
test-unit:
	@echo "Running unit tests..."
	@rm -rf .build/unit-tests.xcresult
	@xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME_APP) \
		-testPlan WallaMarvel \
		-destination '$(DESTINATION)' \
		-only-testing:WallaMarvelTests \
		-only-testing:DataTests \
		-only-testing:DomainTests \
		-only-testing:NetworkingTests \
		-resultBundlePath .build/unit-tests.xcresult \
		test 2>&1 | xcbeautify || xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME_APP) \
		-testPlan WallaMarvel \
		-destination '$(DESTINATION)' \
		-only-testing:WallaMarvelTests \
		-only-testing:DataTests \
		-only-testing:DomainTests \
		-only-testing:NetworkingTests \
		test

# Run UI tests only
test-ui:
	@echo "Running UI tests..."
	@rm -rf .build/ui-tests.xcresult
	@xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME_APP) \
		-testPlan WallaMarvel \
		-destination '$(DESTINATION)' \
		-only-testing:WallaMarvelUITests \
		-resultBundlePath .build/ui-tests.xcresult \
		test 2>&1 | xcbeautify || xcodebuild -project $(PROJECT) \
		-scheme $(SCHEME_APP) \
		-testPlan WallaMarvel \
		-destination '$(DESTINATION)' \
		-only-testing:WallaMarvelUITests \
		test

# Record snapshot reference images (uses dedicated test plan with SNAPSHOT_RECORD=1)
record-snapshots:
	@echo "Recording DesignSystem snapshots..."
	@xcodebuild test -project $(PROJECT) \
		-scheme $(SCHEME_APP) \
		-testPlan WallaMarvel-RecordSnapshots \
		-destination '$(DESTINATION)' \
		-quiet 2>&1 || true
	@echo "Reference images recorded. Run 'make test-all' to verify."

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
	@echo "  make test-all          - Run all tests at once via Xcode Test Plan"
	@echo "  make test-modules      - Run SPM module tests only"
	@echo "  make test-unit         - Run unit tests only"
	@echo "  make test-ui           - Run UI tests only"
	@echo "  make record-snapshots  - Record DesignSystem snapshot reference images"
	@echo "  make lint              - Run SwiftLint analysis"
	@echo "  make lint-fix          - Auto-fix SwiftLint violations"
	@echo "  make clean             - Clean build artifacts"
	@echo "  make help              - Show this help"
