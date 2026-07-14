---
change: CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance
artifact: testing
---

# Testing

- Run `fledge lanes run verify`, which executes the committed verbose Swift build and test tasks.
- Require all 110 tests across five suites to pass without source or test edits.
- Preserve existing hosted macOS and Swift 6.0 Ubuntu builds and tests.
- Require released SpecSync 5.0.1 strict validation at 100% for every parsed export, 25/25 files, and 3,349/3,349 LOC.
- Require all four agent integrations plus Trust doctor and Trust verify.
- Require CodeQL actions/Swift analysis and the immutable hosted Trust job on the exact final head.
- Keep DocC publication independently triggered from main.
