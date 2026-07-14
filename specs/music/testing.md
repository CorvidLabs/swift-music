---
spec: music.spec.md
---

## Test Plan

| Requirement | Evidence |
|---|---|
| REQ-music-001 | Music suite pitch-class transposition, note construction, and A440 calculation plus strict build coverage of remaining exports. |
| REQ-music-002 | Strict native compilation and complete export documentation for `Interval` and `IntervalQuality`. |
| REQ-music-003 | All 27 Scales-suite pattern, mode, rooted scale, relationship, generation, display, preset, equality, and hashing tests. |
| REQ-music-004 | All 26 Chords-suite quality, inversion, slash-bass, extension, note, voicing, symbol, equality, and hashing tests. |
| REQ-music-005 | Music-suite pop-progression realization plus strict compilation of all numeral/progression exports. |
| REQ-music-006 | All 29 Rhythm-suite duration, tempo, marking, time-signature, alias, meter, display, equality, and hashing tests. |
| REQ-music-007 | MIDI-suite value validation, dynamics, channel range, message encoding/parsing, pitch bend, and event ordering tests. |
| REQ-music-008 | MIDI-suite track creation and Standard MIDI File creation, empty/single/multi-track round trips, and invalid-header tests. |
| REQ-music-009 | `fledge lanes run verify`, strict SpecSync 100%, four-agent status, Trust doctor/verify, hosted macOS/Ubuntu, CodeQL, and immutable Trust checks. |

The complete suite contains 110 deterministic tests in five suites. It does not claim behavior for untested invalid theory inputs beyond the current public implementation and explicit MIDI parsing/validation errors.
