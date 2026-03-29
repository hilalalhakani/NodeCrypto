# Xcode Build Optimization Plan


## Project Context

- **Project:** `/Users/hilalhakkani/Desktop/NodeCrypto/NodeCrypto/NodeCrypto.xcodeproj`
- **Scheme:** `NodeCrypto`
- **Configuration:** `Debug`
- **Destination:** `platform=iOS Simulator,name=iPhone 17`
- **Xcode:** Xcode 26.0 Build version 17A324
- **macOS:** macOS-26.1-arm64-arm-64bit
- **Date:** 2026-03-31T04:59:46.395316+00:00
- **Benchmark artifact:** `/Users/hilalhakkani/Desktop/NodeCrypto/.build-benchmark/20260331T044650Z-nodecrypto.json`

## Baseline Benchmarks

| Metric | Clean | Cached Clean | Incremental |
|--------|-------|-------------|-------------|
| Median | 57.014s | 102.306s | 7.914s |
| Min | 55.411s | 99.719s | 7.527s |
| Max | 58.862s | 102.376s | 15.226s |
| Runs | 3 | 3 | 3 |

> **Cached Clean** = clean build with a warm compilation cache. This is the realistic scenario for branch switching, pulling changes, or Clean Build Folder. The compilation cache lives outside DerivedData and survives product deletion.


### Clean Build Timing Summary

> **Note:** These are aggregated task times across all CPU cores. Because Xcode runs many tasks in parallel, these totals typically exceed the actual build wait time shown above. A large number here does not mean it is blocking your build.

| Category | Tasks | Seconds |
|----------|------:|--------:|
| SwiftCompile | 315 | 141.583s |
| CompileAssetCatalogVariant | 10 | 62.963s |
| SwiftDriver | 63 | 38.444s |
| SwiftEmitModule | 63 | 24.199s |
| ExtractAppIntentsMetadata | 59 | 12.011s |
| Ld | 81 | 5.881s |
| CompileC | 50 | 2.768s |
| RegisterExecutionPolicyException | 101 | 1.975s |
| CodeSign | 25 | 1.938s |
| ScanDependencies | 50 | 1.811s |
| Copy | 347 | 1.266s |
| GenerateAssetSymbols | 10 | 0.273s |
| ProcessInfoPlistFile | 23 | 0.227s |
| CpResource | 108 | 0.221s |
| WriteAuxiliaryFile | 680 | 0.214s |
| SwiftDriver Compilation | 63 | 0.115s |
| Touch | 23 | 0.091s |
| SwiftDriver Compilation Requirements | 63 | 0.073s |
| CopySwiftLibs | 1 | 0.047s |
| SwiftMergeGeneratedHeaders | 59 | 0.043s |
| LinkAssetCatalog | 10 | 0.027s |
| AppIntentsSSUTraining | 1 | 0.022s |
| ConstructStubExecutorLinkFileList | 1 | 0.018s |
| ProcessProductPackagingDER | 2 | 0.011s |
| ProcessProductPackaging | 2 | 0.002s |
| CopyPlistFile | 1 | 0.002s |
| Validate | 1 | 0.000s |
| ValidateDevelopmentAssets | 1 | 0.000s |

### Cached Clean Build Timing Summary

> **Note:** These are aggregated task times across all CPU cores. Because Xcode runs many tasks in parallel, these totals typically exceed the actual build wait time shown above. A large number here does not mean it is blocking your build.

| Category | Tasks | Seconds |
|----------|------:|--------:|
| SwiftCompile | 315 | 157.550s |
| SwiftDriver | 63 | 62.615s |
| CompileAssetCatalogVariant | 10 | 61.540s |
| SwiftEmitModule | 63 | 24.109s |
| ExtractAppIntentsMetadata | 59 | 15.767s |
| ScanDependencies | 50 | 7.535s |
| Ld | 81 | 6.056s |
| CompileC | 50 | 2.603s |
| CodeSign | 25 | 2.383s |
| RegisterExecutionPolicyException | 101 | 1.929s |
| Copy | 347 | 1.335s |
| CpResource | 108 | 0.453s |
| WriteAuxiliaryFile | 680 | 0.291s |
| GenerateAssetSymbols | 10 | 0.265s |
| ProcessInfoPlistFile | 23 | 0.247s |
| Touch | 23 | 0.077s |
| SwiftDriver Compilation | 63 | 0.076s |
| SwiftDriver Compilation Requirements | 63 | 0.065s |
| SwiftMergeGeneratedHeaders | 59 | 0.047s |
| CopySwiftLibs | 1 | 0.044s |
| AppIntentsSSUTraining | 1 | 0.027s |
| LinkAssetCatalog | 10 | 0.022s |
| ConstructStubExecutorLinkFileList | 1 | 0.018s |
| ProcessProductPackagingDER | 2 | 0.010s |
| CopyPlistFile | 1 | 0.003s |
| ProcessProductPackaging | 2 | 0.003s |
| Validate | 1 | 0.000s |
| ValidateDevelopmentAssets | 1 | 0.000s |

### Incremental Build Timing Summary

> **Note:** These are aggregated task times across all CPU cores. Because Xcode runs many tasks in parallel, these totals typically exceed the actual build wait time shown above. A large number here does not mean it is blocking your build.

| Category | Tasks | Seconds |
|----------|------:|--------:|
| Copy | 7 | 0.294s |
| ProcessInfoPlistFile | 0 | 0.006s |

## Build Settings Audit

### Debug Configuration

- [x] `SWIFT_COMPILATION_MODE`: `(unset)` (recommended: `incremental`)
- [x] `SWIFT_OPTIMIZATION_LEVEL`: `-Onone` (recommended: `-Onone`)
- [x] `GCC_OPTIMIZATION_LEVEL`: `0` (recommended: `0`)
- [x] `ONLY_ACTIVE_ARCH`: `YES` (recommended: `YES`)
- [x] `DEBUG_INFORMATION_FORMAT`: `dwarf` (recommended: `dwarf`)
- [x] `ENABLE_TESTABILITY`: `YES` (recommended: `YES`)
- [x] `EAGER_LINKING`: `YES` (recommended: `YES`)

### General (All Configurations)

- [x] `COMPILATION_CACHING`: `YES` (recommended: `YES`)

### Release Configuration

- [x] `SWIFT_COMPILATION_MODE`: `wholemodule` (recommended: `wholemodule`)
- [x] `SWIFT_OPTIMIZATION_LEVEL`: `-O` (recommended: `-O`)
- [x] `GCC_OPTIMIZATION_LEVEL`: `s` (recommended: `s`)
- [x] `ONLY_ACTIVE_ARCH`: `NO` (recommended: `NO`)
- [x] `DEBUG_INFORMATION_FORMAT`: `dwarf-with-dsym` (recommended: `dwarf-with-dsym`)
- [x] `ENABLE_TESTABILITY`: `NO` (recommended: `NO`)

### Cross-Target Consistency

- [x] `SWIFT_COMPILATION_MODE` is consistent across all targets
- [x] `SWIFT_OPTIMIZATION_LEVEL` is consistent across all targets
- [x] `ONLY_ACTIVE_ARCH` is consistent across all targets
- [x] `DEBUG_INFORMATION_FORMAT` is consistent across all targets

## Compilation Diagnostics

Threshold: 100ms | Total warnings: 0 | Function bodies: 0 | Expressions: 0

No type-checking hotspots found above threshold.

## Prioritized Recommendations

### 1. Optimize Image Assets in CreateFeature and ConnectWalletFeature
- **Expected wait-time impact:** Expected to reduce your clean build by approximately 5-8 seconds.
- **Evidence:** `CompileAssetCatalogVariant` takes 63s cumulatively. `CreateFeature` has 30MB of assets, including several 5-8MB PNGs (e.g., `Collection1.imageset/image.png`).
- **Affected files:** `Packages/Sources/CreateFeature/Resources/Media.xcassets`, `Packages/Sources/ConnectWalletFeature/Resources/Media.xcassets`.
- **Risk:** Low (requires image compression/resizing).
- **Recommendation:** Compress the large PNG assets using `pngquant` or similar, or resize them to the maximum resolution actually needed by the app. Consider using HEIC or specialized asset types if applicable.

### 2. Enable Task Backtraces for Debugging Incremental Builds
- **Expected wait-time impact:** No immediate wait-time improvement, but critical for diagnosing future regressions.
- **Evidence:** Zero-change builds take ~7.9s, mostly in the "Planning" phase.
- **Affected settings:** Scheme Editor > Build > Build Debugging > "Task Backtraces".
- **Risk:** Low.
- **Recommendation:** Enable Task Backtraces to pinpoint why Xcode decides to re-run tasks during incremental builds.

### 3. Review App Intents Metadata Extraction
- **Expected wait-time impact:** Expected to reduce your clean build by approximately 2-4 seconds if disabled for Debug.
- **Evidence:** `ExtractAppIntentsMetadata` takes 12s cumulatively across 59 tasks.
- **Affected settings:** `ENABLE_APP_INTENTS_METADATA_EXTRACTION`.
- **Risk:** Medium (will break App Intents / Siri functionality in Debug if disabled).
- **Recommendation:** If you are not actively developing Siri/App Intents, consider disabling this phase for Debug configuration to shave off a few seconds of serial planning time.

### 4. Pin Branch-Based Dependencies
- **Expected wait-time impact:** Reduces "Scan Dependencies" cost (currently 1.8s-7.5s) and prevents unexpected background package resolution.
- **Evidence:** `swift-dependencies-additions` is tracking the `xcode26` branch instead of a version or specific revision.
- **Affected files:** `Packages/Package.swift`.
- **Risk:** Very Low.
- **Recommendation:** Pin `swift-dependencies-additions` to a specific revision or version tag to improve determinism and reduce scanning overhead.

## Approval Checklist

- [ ] [LO] Optimize `CreateFeature` and `ConnectWalletFeature` assets (reduce ~40MB of PNG data)
- [ ] [LO] Enable Task Backtraces in NodeCrypto scheme
- [ ] [ME] Disable App Intents Metadata Extraction for Debug
- [ ] [LO] Pin `swift-dependencies-additions` to a specific revision

## Next Steps

After implementing approved changes, re-benchmark with the same inputs:

```bash
python3 scripts/benchmark_builds.py \
  --project /Users/hilalhakkani/Desktop/NodeCrypto/NodeCrypto/NodeCrypto.xcodeproj \
  --scheme NodeCrypto \
  --configuration Debug \
  --destination "platform=iOS Simulator,name=iPhone 17" \
  --output-dir .build-benchmark
```

Compare the new wall-clock medians against the baseline. Report results as:
"Your [clean/incremental] build now takes X.Xs (was Y.Ys) -- Z.Zs faster/slower."
