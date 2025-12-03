# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-02

### Added

#### Core Module
- `PitchClass` enum representing the twelve chromatic pitch classes
- `NoteName` for note names with enharmonic spellings
- `Note` struct combining pitch class with octave
- `Frequency` utilities for frequency conversion and cents calculation

#### Intervals Module
- `IntervalQuality` enum (perfect, major, minor, augmented, diminished)
- `Interval` struct with inversion support
- Common interval constants (major third, perfect fifth, etc.)

#### Scales Module
- `ScalePattern` with major, minor, modal, pentatonic, and blues patterns
- `Scale` struct with note generation and scale relationships
- Support for relative and parallel scale relationships

#### Chords Module
- `ChordQuality` for triads and seventh chords
- `ChordExtension` for alterations (add9, flat9, sharp11, etc.)
- `Chord` struct with extension and slash chord support
- `Voicing` with drop-2, drop-3, and close voicing algorithms

#### Progressions Module
- `RomanNumeral` for chord notation
- `ChordProgression` with common progressions (I-V-vi-IV, ii-V-I, 12-bar blues)
- Progression transposition support

#### Rhythm Module
- `NoteDuration` for rhythmic values (whole, half, quarter, etc.)
- `Tempo` with BPM and duration calculations
- `TimeSignature` with meter properties

#### MIDI Module
- `MIDINote` for MIDI note numbers (0-127)
- `MIDIVelocity` with dynamic markings (pp, p, mp, mf, f, ff)
- `MIDIChannel` for MIDI channels (1-16)
- `MIDIMessage` for message encoding and decoding
- `MIDIEvent` for timed MIDI messages
- `MIDITrack` for organizing MIDI events
- `MIDIFile` with complete MIDI file encoding and decoding support

### Documentation
- Comprehensive README with usage examples
- Full API documentation with DocC
- Examples.md with detailed code examples
- CI/CD workflow for automated testing and documentation deployment

### Technical
- Swift 6.0 with strict concurrency support
- All types are `Sendable` for safe concurrent usage
- Protocol-oriented design with value types
- Zero external dependencies (except swift-docc-plugin)
- Support for iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, visionOS 1+
