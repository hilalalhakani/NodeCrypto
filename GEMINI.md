# Gemini Project Configuration

## Project Overview

This is a native iOS application named "NodeCrypto," built with Swift and SwiftUI. The project follows a modular architecture using Swift Package Manager, with features and core components organized into individual packages.

The core architecture is built upon The Composable Architecture (TCA), promoting a unidirectional data flow and making state management, composition, and testing more predictable.

Key third-party dependencies include:
- **The Composable Architecture (TCA):** For the core application architecture.
- **Firebase:** For analytics, crash reporting, and performance monitoring.
- **Kingfisher:** For asynchronous image downloading and caching.
- **Swift Snapshot Testing:** For UI and snapshot testing.

## Build & Run

The project is managed through Xcode. To build and run:

1.  Open `NodeCrypto/NodeCrypto.xcodeproj`.
2.  Select the `NodeCrypto` scheme.
3.  Choose a simulator (e.g., iPhone 15 on iOS 18.1, as specified in `test.sh`) or a connected device.
4.  Click the "Run" button.

## Testing

To run tests, you can use the provided test script, which leverages `xcbeautify` for cleaner output:

```bash
./build_scripts/test.sh
```
Alternatively, you can run tests from within Xcode using the Test navigator. The project includes unit tests and snapshot tests for various features.


## CI/CD

The project uses GitHub Actions for continuous integration. The workflow is defined in `.github/workflows/ios.yml`. It automatically builds the project, runs tests, and checks for linting issues on every push and pull request to the `main` and `develop` branches.

## Project Structure

The codebase is organized into Swift Packages, located in the `Packages/` directory.

-   **`NodeCrypto/`**: The main application target, containing the `App.swift` entry point, `Info.plist`, and asset catalogs.
-   **`NodeCrypto.xcodeproj`**: The Xcode project file that orchestrates the build process.
-   **`Packages/`**: Contains all the local Swift packages.
    -   **`Sources/`**: The source code for each package.
        -   **Feature Modules** (e.g., `AppFeature`, `HomeFeature`, `ProfileFeature`): Each feature of the app is a self-contained module with its own TCA state, actions, reducer, and view.
        -   **Core Modules** (e.g., `APIClient`, `AuthenticationClient`, `Keychain`, `NodeCryptoCore`): Provide shared functionality, services, and core logic used across different features.
        -   **Shared UI** (`SharedViews`, `StyleGuide`): Contain reusable SwiftUI views and style definitions (colors, fonts).
    -   **`Tests/`**: Contains unit and snapshot tests for each corresponding package.

## Coding Conventions

-   **The Composable Architecture (TCA):** All new features should be built using TCA patterns. Adhere to the established structure of `State`, `Action` (with `view`, `internal`, and `delegate` cases), and `Reducer`.
-   **Modularity:** New features or shared components should be created as new Swift Packages within the `Packages/` directory to maintain a clean and decoupled architecture.
-   **Dependency Injection:** Dependencies are managed using the `@Dependency` property wrapper from `swift-dependencies`. Use the `APIClient` and other clients for interacting with external services. Mock implementations for previews and tests are defined alongside the live implementations (e.g., `APIClient.swift`).
-   **UI and Styling:** Build UI with SwiftUI. Use components from `SharedViews` for reusable elements and refer to `StyleGuide` for fonts and colors to ensure a consistent look and feel.
-   **Asynchronous Operations:** Use modern Swift Concurrency (`async/await`) for asynchronous tasks, as seen in the API request handling within the feature reducers.
-   **Code Style:** Follow the existing code style and the rules defined in `.swiftlint.yml`.

## Design

All UI development should strictly adhere to the designs specified in the project's Figma file. Ensure that all layouts, components, colors, and fonts match the design specifications to maintain visual consistency.

-   **Figma Design File:** [https://www.figma.com/design/QEz9GsPLGotV5SAJGwdqfZ/Node-Crypto-NFT-iOS-UI-Kit?node-id=1603-42798]

## My Tool Usage

I will use the instructions in this `GEMINI.md` file as my primary guide for all project-specific tasks like building, testing, and linting.

For tasks that require external knowledge, such as fetching up-to-date documentation, I will use my internal documentation retrieval tool, which you've referred to as **Context7 MCP**.

You can ask me to use this tool for:
-   **SwiftUI:** Getting documentation and examples for SwiftUI components and APIs.
-   **Package Information & Documentation:** Finding information and usage examples for any of the packages listed in `Package.swift` (e.g., `swift-composable-architecture`, `Kingfisher`).

In short:
-   **For your project's code:** I'll follow the rules in this file.
-   **For SwiftUI & external library docs:** I'll use my documentation retrieval tool (Context7 MCP).
