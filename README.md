# WallaMarvel

A superhero browsing app built for Wallapop's iOS Tech Test. The app fetches heroes with pagination, search, and rich detail screens including animated power stats.

## Screenshots

| Heroes List | Hero Detail | Search |
|:-:|:-:|:-:|
| ![List](docs/screenshot_list.png) | ![Detail](docs/screenshot_detail.png) | ![Search](docs/screenshot_search.png) |

## API Choice

The original Marvel API was experiencing downtime (HTTP 500). As suggested in the task requirements, this implementation uses the **[Superhero API](https://akabab.github.io/superhero-api/)** - a free, open-source API hosted on GitHub Pages with 731 superheroes from Marvel, DC, and other publishers.

The clean architecture made this swap straightforward: only the `Core/SuperheroAPI` and `Data` layers changed. Domain models, Use Cases, ViewModels, and Views were adapted to the new data shape but the overall architecture remained intact. This demonstrates how proper layer separation protects the codebase from external API changes.

**Key difference**: The Superhero API returns all heroes in a single response. The repository fetches once and caches in memory via an actor-isolated cache, then serves paginated pages and filtered search results client-side. This is a realistic pattern for catalog-sized datasets.

## Architecture

### Dependency Graph

![Dependency Graph](docs/dependency_graph.png)

Arrows only point downward. Presentation depends on Domain, never the reverse. Data implements Domain protocols (dashed line) but Domain has no knowledge of Data.

### MVVM + Clean Architecture

```
WallaMarvel/
├── App/                        # Entry point, RootView, DependencyContainer
├── Core/                       # Infrastructure
│   ├── Network/                # Generic HTTP client, error types, endpoint protocol
│   └── SuperheroAPI/           # Superhero API endpoints & DTOs
├── Domain/                     # Business logic (pure Swift, no framework imports)
│   ├── Models/                 # Domain entities (Hero, HeroesPage, PowerStats)
│   ├── Repositories/           # Repository protocols (abstractions)
│   └── UseCases/               # Application-specific business rules
├── Data/                       # Data layer implementations
│   ├── Repositories/           # Repository with actor-based cache & client-side pagination
│   ├── DataSources/            # Remote data source (Superhero API)
│   └── Mappers/                # DTO → domain model transformations
└── Presentation/               # UI layer (SwiftUI)
    ├── HeroesList/             # Heroes list feature with search
    ├── HeroDetail/             # Hero detail with power stats
    └── Components/             # ErrorStateView, PowerStatsView, DetailSectionView, ViewModifiers
```

**Why this structure?**
- **Dependency Rule**: Inner layers (Domain) have zero knowledge of outer layers (Data, Presentation). The Domain defines repository protocols; the Data layer provides implementations.
- **Testability**: Every layer boundary is defined by a protocol, making it straightforward to inject mocks for testing.
- **Single Responsibility**: Each file has one clear purpose. ViewModels handle state logic, Views handle rendering, Use Cases encapsulate business operations.

### Key Design Decisions

| Decision | Rationale |
|---|---|
| **SwiftUI** over UIKit | Modern declarative UI with less boilerplate. NavigationStack for type-safe navigation. |
| **async/await** over completion handlers | Structured concurrency is cleaner, eliminates callback hell, and integrates naturally with SwiftUI's `.task` modifier. |
| **Actor-based cache** | `HeroCache` is an actor ensuring thread-safe access to the in-memory hero store from concurrent async calls. |
| **Client-side pagination** | The API returns all heroes at once. The repository caches and serves paginated slices - instant page loads after initial fetch. |
| **iOS 18 zoom transition** | `matchedTransitionSource` / `navigationTransition(.zoom)` for hero image morphing, with graceful `#available` fallback for iOS 16–17. |
| **Protocol-oriented DI** | Constructor injection via protocols. `DependencyContainer` is the composition root - no third-party DI framework needed. |
| **XcodeGen** for project generation | Eliminates merge conflicts in `.xcodeproj` and makes project configuration declarative via `project.yml`. |
| **Separate DTO and Domain models** | DTOs mirror the API response; domain models are shaped for the app. `HeroMapper` decouples the app from API changes. |
| **Debounced search** | 300ms debounce prevents excessive UI updates while the user types. |

## Features Implemented

### Must-have
- **Hero Detail Screen**: Tapping a hero navigates to a detail screen showing name, full name, publisher/alignment badges, animated power stats bars, first appearance, aliases, and group affiliations.
- **Pagination**: Infinite scroll - when the user reaches the last item, the next page loads automatically. Pagination state is tracked in the ViewModel.

### Nice-to-have
- **Search Bar**: Built-in `.searchable` modifier with debounced filtering. Client-side case-insensitive name search across 731 heroes.
- **Structured Concurrency**: Full async/await throughout. Actor-isolated cache for thread safety.
- **SwiftUI**: Entire UI built with SwiftUI - NavigationStack, List, ScrollView, and custom animated stat bars.
- **Accessibility**: Accessibility identifiers, labels, hints, and traits. Screen reader support with `.accessibilityElement(children:)`, `.accessibilityAddTraits(.isHeader)`, `.accessibilityHidden(true)` for decorative images. Power stat bars announce values.
- **Animations**: See below.

## Animations

Three layers of interactive animation enhance the user experience:

| Animation | Description | iOS Requirement |
|---|---|---|
| **Zoom transition** | Hero cell morphs into the detail screen via `matchedTransitionSource` and `navigationTransition(.zoom)`. `RootView` owns the `@Namespace` shared between list and detail. | iOS 18+ (graceful fallback) |
| **Staggered sections** | Detail screen sections (name, badges, stats, aliases, affiliations) slide up and fade in sequentially with spring physics and 80ms stagger. | iOS 16+ |
| **Power stats bars** | All 6 stat bars animate from zero width to actual value with staggered spring animations (60ms between bars, 0.8s spring response). | iOS 16+ |

Animations are isolated in `ViewModifiers.swift` and applied declaratively. The `StaggeredAppearance` modifier and transition helpers keep view code clean.

## Testing Strategy

### Unit Tests - 31 tests, all passing

| Test Suite | Count | What's tested |
|---|---|---|
| `HeroRepositoryTests` | 8 | Client-side pagination, caching (single fetch), search filtering, case-insensitive search, error propagation, detail lookup |
| `HeroMapperTests` | 5 | DTO-to-domain mapping, power stats, image URLs, alias filtering, nil publisher handling |
| `SuperheroEndpointTests` | 4 | URL construction, path correctness, base URL, query items |
| `HeroesListViewModelTests` | 9 | Initial load, pagination, error states, retry, idempotent loading, hasMorePages |
| `HeroDetailViewModelTests` | 5 | Load, error handling, retry, idempotent loading |

**Unit test approach:**
- Every protocol has a corresponding mock in `WallaMarvelTests/Mocks/`
- `TestData` factory provides consistent test fixtures with builder-pattern defaults
- ViewModels tested with `@MainActor` for proper actor isolation
- Tests verify behavior (state transitions), not implementation details

### UI Tests - 11 tests, all passing

| Test | What it verifies |
|---|---|
| `test_heroesList_showsNavigationTitle` | "Marvel Heroes" title appears on launch |
| `test_heroesList_showsSearchBar` | Search bar with placeholder text is visible |
| `test_heroesList_displaysHeroes` | Heroes load from the API and first hero ("A-Bomb") is visible |
| `test_heroesList_showsPublisherInfo` | Publisher info ("Marvel Comics") appears in list rows |
| `test_tappingHero_navigatesToDetail` | Tapping a hero navigates to its detail screen |
| `test_heroDetail_showsPowerStats` | Detail screen shows "Power Stats" section |
| `test_heroDetail_showsStatLabels` | Intelligence, Strength, Speed labels are present |
| `test_heroDetail_backButtonReturnsToList` | Back button returns to the heroes list |
| `test_search_filtersHeroesByName` | Typing "Batman" filters the list to show Batman |
| `test_search_showsEmptyStateForNoResults` | Gibberish search shows "No heroes found" empty state |
| `test_scrollingDown_showsMoreHeroes` | Scrolling down loads additional hero pages |

### Launch Tests - 2 tests, all passing

| Test | What it verifies |
|---|---|
| `test_launch_showsMainScreen` | App launches to the Marvel Heroes screen with search bar (runs for each UI configuration) |
| `test_launchPerformance` | Measures app launch time via `XCTApplicationLaunchMetric` - **avg 0.9s** |

**UI test approach:**
- Network-dependent tests use 30s timeout for the initial ~2MB JSON download
- Navigation detection via navigation bar title changes (robust with SwiftUI)
- Helper methods (`waitForHeroesToLoad`, `navigateToFirstHeroDetail`) reduce duplication

### Running all tests

```bash
# Unit tests (31 tests)
xcodebuild test -scheme WallaMarvelTests -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# UI tests (11 tests) + Launch tests (2 tests)
xcodebuild test -scheme WallaMarvelUITests -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

## Development Infrastructure

### Build System

| Feature | Detail |
|---|---|
| **XcodeGen** | Project generated from declarative `project.yml` - no `.xcodeproj` merge conflicts |
| **Strict concurrency** | `SWIFT_STRICT_CONCURRENCY = targeted` for Swift 6 readiness |
| **Warnings as errors** | `SWIFT_TREAT_WARNINGS_AS_ERRORS = YES` in Release builds |
| **Code coverage** | Enabled in Debug for unit test coverage reporting |
| **Dead code stripping** | `DEAD_CODE_STRIPPING = YES` for smaller binaries |
| **Module verification** | `ENABLE_MODULE_VERIFIER = YES` for build correctness |

### CI/CD - GitHub Actions

The `.github/workflows/ci.yml` pipeline runs on every PR and push to `main`:

```
lint (SwiftLint) → build → unit-tests (parallel)
                         → ui-tests   (parallel)
```

- **Concurrency**: Cancels in-progress runs for the same branch
- **Caching**: SPM packages cached between runs
- **Artifacts**: `.xcresult` bundles uploaded for test failure triage
- **Code coverage**: Enabled on unit test step

### Quality Assurance - SwiftLint

**0 violations** across 36 files. Configuration in `.swiftlint.yml`:

- 30+ rules enabled including `closure_spacing`, `empty_count`, `first_where`, `modifier_order`, `sorted_first_last`, `toggle_bool`
- Line length: 140 warning / 200 error
- Integrated as a **pre-build script** in Xcode - violations show inline in the editor
- `force_unwrapping` and `implicitly_unwrapped_optional` intentionally not enabled (they flag standard XCTest patterns)

### Makefile

Common developer commands via `make`:

```bash
make build      # Generate project + build
make test       # Run all tests (unit + UI)
make test-unit  # Run unit tests only
make test-ui    # Run UI tests only
make lint       # Run SwiftLint analysis
make lint-fix   # Auto-fix SwiftLint violations
make clean      # Clean build artifacts
make help       # Show all available targets
```

### Other Tooling

| File | Purpose |
|---|---|
| `.editorconfig` | Consistent indentation (4 spaces for Swift, 2 for YAML) and encoding across editors |
| `.gitignore` | Updated for modern iOS tooling: XcodeGen, SwiftLint, SPM, no CocoaPods/Carthage artifacts |

## Improvements Over Original Code

| Original Issue | Fix |
|---|---|
| `try!` force unwrapping in APIClient | Typed `APIError` enum with user-facing messages |
| Completion handler API | Full async/await with structured concurrency |
| UITableView with MVP | SwiftUI with MVVM |
| No detail screen | Rich detail: power stats, publisher, aliases, affiliations |
| No pagination | Infinite scroll with client-side page tracking |
| No search | Debounced client-side search by name |
| No tests (empty templates) | 31 unit + 11 UI + 2 launch = **44 tests** |
| No error handling UI | `ErrorStateView` with retry |
| Cell tap → infinite VC loop | NavigationStack with `.navigationDestination` |
| No animations | iOS 18 zoom transition, staggered sections, animated stat bars |
| No accessibility | Identifiers, labels, hints, traits throughout |
| Manual .xcodeproj | XcodeGen with declarative `project.yml` |
| No CI/CD | GitHub Actions: lint → build → unit tests → UI tests |
| No linting | SwiftLint with 30+ rules, 0 violations |
| No dev tooling | Makefile, `.editorconfig`, optimized build settings |
| Marvel API down (500) | Switched to reliable Superhero API (GitHub Pages) |

## Build & Run

**Requirements:** Xcode 16+, iOS 16+ simulator

```bash
# Quick start (requires xcodegen and swiftlint: brew install xcodegen swiftlint)
make build

# Or manually:
xcodegen generate
xcodebuild -project WallaMarvel.xcodeproj -scheme WallaMarvel build

# Run all tests
make test

# Or manually:
xcodebuild test -scheme WallaMarvelTests -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
xcodebuild test -scheme WallaMarvelUITests -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# Lint
make lint
```

Or open `WallaMarvel.xcodeproj` in Xcode and run.

## Dependencies

| Dependency | Purpose |
|---|---|
| [Kingfisher](https://github.com/onevcat/Kingfisher) 8.x | Async image downloading and caching with SwiftUI integration |

**Dev dependencies** (not bundled, installed via Homebrew):

| Tool | Purpose |
|---|---|
| [XcodeGen](https://github.com/yonaskolb/XcodeGen) | Generate `.xcodeproj` from `project.yml` |
| [SwiftLint](https://github.com/realm/SwiftLint) | Static analysis and style enforcement |

## Security Considerations

| Measure | Detail |
|---|---|
| **TLS 1.2 minimum** | `URLSessionConfiguration.tlsMinimumSupportedProtocolVersion = .TLSv12` prevents protocol downgrade attacks |
| **No disk caching** | `urlCache = nil` and `.reloadIgnoringLocalCacheData` prevent sensitive API responses from being written to disk |
| **HTTPS only** | All API endpoints use HTTPS. The original `NSAllowsArbitraryLoads = true` (which allowed HTTP) has been removed |
| **No hardcoded secrets** | The Superhero API requires no API keys. The original Marvel API embedded private keys in source code - this was a significant security flaw |
| **Input validation** | HTTP status codes are validated (200-299 range). Decoding errors are caught and wrapped in typed errors |
| **Actor isolation** | `HeroCache` uses a Swift actor to prevent data races in concurrent access |

**Not implemented** (would add for a production app): Certificate pinning - out of scope for a GitHub Pages-hosted static JSON API, but the `URLSession` configuration is injectable so a pinning delegate could be added without changing the `HTTPClient` protocol.

## SOLID Principles Applied

- **S** - Single Responsibility: Each class/struct has one job (`HeroMapper` only maps, `URLSessionHTTPClient` only executes requests)
- **O** - Open/Closed: New endpoints extend `SuperheroEndpoint` without modifying existing code. New data sources implement `HeroRemoteDataSourceProtocol`.
- **L** - Liskov Substitution: All mocks are drop-in replacements for their protocols in tests
- **I** - Interface Segregation: Focused protocols (`FetchHeroesUseCaseProtocol` vs `SearchHeroesUseCaseProtocol` vs `FetchHeroDetailUseCaseProtocol`)
- **D** - Dependency Inversion: Presentation depends on abstractions (protocols), not concrete implementations. The API swap proved this works in practice.
