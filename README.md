# Anatomy

## Continuous Integration
- **GitHub Actions iOS CI** (`.github/workflows/ci.yml`)
  - Runs `xcodebuild test` on `macos-latest` with configurable `XCODE_WORKSPACE`, `XCODE_PROJECT`, `XCODE_SCHEME`, and `XCODE_DESTINATION` repository variables.
  - Lints bundled JSON data on Ubuntu using `scripts/validate_bundle_data.py` and publishes a report artifact.
- **TestFlight Deployment** (`.github/workflows/testflight.yml`)
  - Manual `workflow_dispatch` to archive and export for TestFlight using App Store Connect API key credentials (configured as repository secrets).
  - Archives the selected workspace/project, exports an IPA with the provided provisioning profile, and uploads the build and archive as artifacts.

## Bundle data validation
1. Install tools:
   ```bash
   python -m pip install -r requirements-dev.txt
   ```
2. Run validation locally:
   ```bash
   python scripts/validate_bundle_data.py --schema schema/bundle-data.schema.json --data data/bundles
   ```
3. CI writes results to `bundle-validation-report.txt` and publishes it as an artifact.
4. Bundles are stored in `data/bundles/*.json` using the anatomy entity schema (see `data/bundles/upper_limb_muscles.json`).

## Notes for deployment
- Configure these repository secrets before running the TestFlight workflow:
  - `APP_STORE_CONNECT_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, `APP_STORE_CONNECT_PRIVATE_KEY`, `APP_STORE_CONNECT_TEAM_ID`
  - `APP_BUNDLE_ID`, `SIGNING_CERTIFICATE`, `PROVISIONING_PROFILE_SPECIFIER`
- Override inputs when dispatching the workflow to point to the correct workspace/project, scheme, configuration, and destination.
