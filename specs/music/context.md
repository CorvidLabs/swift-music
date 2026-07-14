---
spec: music.spec.md
---

## Context

Swift Music is a small cross-platform theory and MIDI value library rather than an audio engine, sequencer, notation renderer, or platform-framework adapter. Its public contract is the declared semitone formulas, string/symbol representations, range handling, collection ordering, MIDI bytes, and binary file round trips already implemented in the 25 source files.

## Related Modules

- Foundation supplies frequency math and MIDI binary data support.
- Swift DocC generates public documentation independently from pull-request verification.

## Design Decisions

- Represent chromatic theory as pitch classes and integer semitone offsets instead of key-aware notation spelling.
- Represent absolute notes through the MIDI-number convention where C4 is 60 and A4 is 69/440 Hz.
- Keep theory values immutable and Sendable; expose mutation only for track/file collection assembly.
- Encode MIDI channel messages directly and parse supported channel/system-exclusive messages into typed values.
- Preserve separate macOS/Linux native matrices, CodeQL, and push-only DocC Pages publication around the unified Trust gate.
