---
spec: music.spec.md
---

## Requirements

### REQ-music-001
The library SHALL expose twelve pitch classes, enharmonic note names, absolute notes, and A4=440 equal-temperament frequency/cents conversions with the documented MIDI numbering, modular transposition, ordering, hashing, and display semantics.

Acceptance Criteria
- The Music suite passes its pitch-class, note, frequency, and conversion assertions.

### REQ-music-002
The library SHALL expose interval qualities and common intervals with committed symbols, semitone counts, inversion rules, descriptions, equality, and hashing.

Acceptance Criteria
- All interval exports are documented and strict native build/type checking passes.

### REQ-music-003
The library SHALL expose committed scale/mode patterns, rooted pitch-class generation, membership, octave/count note generation, relative/parallel major-minor derivation, names, equality, and hashing.

Acceptance Criteria
- All 27 Scales-suite tests pass, including pattern, mode, key, range, relationship, preset, equality, and hashing cases.

### REQ-music-004
The library SHALL expose chord qualities, extensions, pitch classes, slash basses, octave notes, valid inversions, symbols, common chord constants, and sorted close/drop voicings.

Acceptance Criteria
- All 26 Chords-suite tests pass across triads, sevenths, inversions, extensions, voicings, symbols, equality, and hashing.

### REQ-music-005
The library SHALL resolve Roman-numeral scale degrees into chords and provide transposable common major, minor, pop, jazz, blues, and circle progressions.

Acceptance Criteria
- Progression realization is covered by the Music suite and every progression/numeral export remains compile-checked.

### REQ-music-006
The library SHALL expose whole-through-sixty-fourth note durations, dotted/double-dotted/triplet ratios, BPM conversion, traditional tempo markings, and time-signature classification, strong beats, aliases, and collections.

Acceptance Criteria
- All 29 Rhythm-suite tests pass across duration, tempo, marking, meter, display, equality, hashing, and preset behavior.

### REQ-music-007
The library SHALL validate MIDI notes, velocities, and channels; encode and parse supported channel/system-exclusive messages; preserve message equality by bytes; and provide timed event ordering and descriptions.

Acceptance Criteria
- MIDI value, byte encoding, parsing-roundtrip, pitch-bend, event-ordering, and error tests pass.

### REQ-music-008
The library SHALL assemble, sort, filter, and measure named MIDI tracks and SHALL encode/decode Standard MIDI File formats 0, 1, and 2 with big-endian chunks, variable-length delta times, track names, running status, SysEx handling, and end-of-track termination.

Acceptance Criteria
- MIDI track/file creation, empty/single/multi-track round trips, and invalid-header tests pass.

### REQ-music-009
The repository SHALL govern all 25 source files at 100% SpecSync file and line coverage and retain blocking native Swift build/test verification on macOS and Swift 6.0 Linux without invoking DocC deployment.

Acceptance Criteria
- Released SpecSync 5.0.1 reports every parsed export and 3,349/3,349 LOC.
- All 110 tests across five suites pass locally and on the preserved hosted matrices.

## Out of Scope

- Audio synthesis/playback, real-time sequencing, MusicXML, notation rendering, key-aware enharmonic spelling, microtonal tuning, tempo maps, SMPTE MIDI divisions, and release/publication changes.
