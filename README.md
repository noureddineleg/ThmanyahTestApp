## ThmanyahTestApp – Coding Rules & Guide

This project is a SwiftUI iOS app structured around **clean separation of concerns**, **protocol‑based services**, and a **centralized networking layer**. This document summarizes the main rules to follow when working in this codebase.

### Architecture & Layers

- **UI (SwiftUI Views)**
  - Renders data only; it does not perform networking or own business logic.
  - Uses `@StateObject` / `@EnvironmentObject` stores for state.
  - Handles navigation, alerts, and presentation logic.

- **Stores / ViewModels**
  - `@MainActor` `ObservableObject` types (e.g. `HomeStore`).
  - Expose `@Published` properties as the single source of truth for the UI.
  - Contain state transitions, loading flags, and business logic.
  - Depend only on **protocols**, injected via initializers.

- **Services**
  - One protocol per feature or domain (e.g. `HomeServiceProtocol`).
  - Implement async/await methods that return typed DTOs only.
  - Call `NetworkingManager` to perform HTTP requests.
  - Have both **real** and **mock** implementations.

- **Networking**
  - All HTTP goes through `NetworkingManager` conforming to `NetworkingManaging`.
  - Alamofire (if used) lives **only** inside networking infrastructure.
  - Endpoints are modeled explicitly (path, method, params, headers, mock file).

### Dependency Injection

- **Depend on protocols, not concretes**
  - Stores receive protocol‑typed services:
    - `init(service: FeatureServiceProtocol = FeatureService())`
  - Enables easy testing and previews using mocks.

- **Composition root**
  - `DependencyContainer` is responsible for wiring:
    - Networking manager
    - Services (real or mock)
    - Stores
  - Environment (Debug / Release) is selected here, not deep in feature code.

### Navigation Rules

- Use `NavigationStack` with a shared `NavigationManager` per feature root:
  - `@StateObject private var navigation = NavigationManager()`
  - `NavigationStack(path: $navigation.path) { ... } .environmentObject(navigation)`
- Define a **strongly‑typed route enum** per feature:
  - Example: `enum HomeRoute: Hashable { case details(id: String) }`
- Centralize destination building inside the route enum:
  - `extension HomeRoute { @ViewBuilder var view: some View { ... } }`
- Register destinations with:
  - `.navigationDestination(for: HomeRoute.self) { $0.view }`
- Push/pop via `NavigationManager`:
  - `navigation.path.append(.details(id: item.id))`
  - `navigation.path.removeLast()` / helper methods like `popToRoot()`.
- Stores, services, and networking **must not** perform navigation.

### State Management

- Stores are `@MainActor` and `ObservableObject`.
- Standard async pattern:
  - `isLoading = true` with `defer { isLoading = false }`.
- Separate domain/shared state (stores, session, forms) from local view state (`@State`).
- Prefer **derived state** instead of duplicate fields (e.g. formatted strings, filters).

### Testing Strategy (XCTest)

- Focus tests on:
  - Store / ViewModel state transitions and error handling.
  - Service behavior (correct endpoints, decoding, error propagation).
  - Networking decoding using bundled mock JSON.
  - Route enums when they carry logic or parameters.
- Use protocol‑based DI and mocks:
  - `FeatureStore(service: FeatureServiceMock())`
- Avoid:
  - Real network calls.
  - Timing‑sensitive async tests and flaky external dependencies.

### Mock Data & Debug JSON

- Debug builds and tests should use bundled JSON that mirrors the real API.
- Mock services load JSON from the bundle and decode using the same models:
  - Ensures the contract between API and models stays in sync.
- Update mock JSON whenever the production API changes.

### Configuration & Secrets

- **Never** hardcode secrets or environment‑specific values in Swift files.
- Use a central config layer, e.g. `AppConfig`, that reads from `Info.plist` / xcconfigs:
  - Example keys: `BASE_API_URL`, `APP_ENVIRONMENT`.
- Support multiple environments (Debug / Staging / Release) via build settings or configs.

### Git & Repository Hygiene

- Do not commit:
  - Secrets, local overrides, generated credentials.
  - Derived data, build products, user‑specific Xcode files.
- Use `.gitignore` to keep the repo clean and safe.
- If configuration files are needed, provide `*.example` templates only.

### UI & Design System

- Extract reusable components (buttons, cards, loaders, empty states) when shared.
- Centralize styling (colors, fonts, spacing, radius, shadows) in a design system.
- Keep SwiftUI previews powered by mock stores and mock services for stability.

### How to Add a New Feature (Quick Checklist)

1. **Define models and endpoints**
   - Create DTOs and an endpoint enum or type.
2. **Create a service protocol and implementations**
   - Real service using `NetworkingManager`.
   - Mock service using bundled JSON.
3. **Add a store**
   - `@MainActor` `ObservableObject` with `@Published` state.
   - Inject the service protocol.
4. **Add views**
   - Use the store as `@StateObject` / `@EnvironmentObject`.
   - Handle loading, success, empty, and error states.
5. **Wire in DI and navigation**
   - Register the store and service in `DependencyContainer`.
   - Add routes and `NavigationStack` entries where appropriate.

Following these rules keeps the project **maintainable**, **testable**, and **production‑ready** as it grows.

