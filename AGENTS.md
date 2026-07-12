<!-- CorvidLabs trust toolchain: BEGIN (managed, do not edit inside) -->
## CorvidLabs trust toolchain

- Use SpecSync 5 for the verified SDD change lifecycle.
- Run `specsync check --strict --force`; coverage remains advisory at 0 until a canonical spec and threshold are committed.
- Keep Claude, Cursor, Codex, and Gemini integrations installed and verify them with `specsync agents status`.
- Treat `.trust.toml` as the policy authority and run `fledge trust doctor` plus `fledge trust verify`.
- Preserve the macOS and Ubuntu Swift matrices, library public API, and independent DocC Pages workflow.
- Do not approve or close an SDD change on behalf of a human owner.
<!-- CorvidLabs trust toolchain: END (managed, do not edit inside) -->
