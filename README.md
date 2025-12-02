# swift-music

[![CI](https://github.com/0xLeif/swift-music/actions/workflows/ci.yml/badge.svg)](https://github.com/0xLeif/swift-music/actions/workflows/ci.yml)
[![Documentation](https://github.com/0xLeif/swift-music/actions/workflows/docs.yml/badge.svg)](https://github.com/0xLeif/swift-music/actions/workflows/docs.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xLeif%2Fswift-music%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0xLeif/swift-music)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xLeif%2Fswift-music%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0xLeif/swift-music)

A comprehensive Swift package for music theory, providing elegant, protocol-oriented abstractions for working with musical concepts including notes, scales, chords, progressions, rhythm, and MIDI.

## Features

- **Pure Swift 6** with strict concurrency support
- **All types are Sendable** for safe concurrent usage
- **No external dependencies** (except swift-docc-plugin for documentation)
- **Protocol-oriented design** with value types
- **Comprehensive MIDI support** including file encoding/decoding
- **Type-safe** with strong compile-time guarantees

## Supported Platforms

- iOS 15.0+
- macOS 11.0+
- tvOS 15.0+
- watchOS 8.0+
- visionOS 1.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/0xLeif/swift-music.git", from: "0.1.0")
]
```

Or in Xcode:
1. File → Add Package Dependencies...
2. Enter package URL: `https://github.com/0xLeif/swift-music.git`
3. Select version and add to your target

## Usage

### Notes and Pitch Classes

```swift
import Music

// Create pitch classes
let c = PitchClass.c
let e = c.transposed(by: 4)  // E

// Create notes
let middleC = Note.middleC
let a440 = Note.a440

// Work with frequencies
let frequency = Frequency.fromMIDI(69)  // 440.0 Hz
let note = Frequency.toNote(440.0)      // A4
```

### Scales

```swift
// Create scales
let cMajor = Scale(root: .c, pattern: .major)
let dDorian = Scale(root: .d, pattern: .dorian)

// Get pitch classes in a scale
let pitchClasses = cMajor.pitchClasses  // [C, D, E, F, G, A, B]

// Generate notes in a scale
let notes = cMajor.notes(from: 3, to: 5)

// Check if a note is in a scale
cMajor.contains(.f)  // true

// Get relative and parallel scales
let aMinor = cMajor.relative   // A natural minor
let cMinor = cMajor.parallel   // C natural minor
```

### Chords

```swift
// Create chords
let cMaj = Chord(root: .c, quality: .major)
let dm7 = Chord(root: .d, quality: .minor7)
let g7 = Chord(root: .g, quality: .dominant7)

// Add extensions
let dm9 = Chord(
    root: .d,
    quality: .minor7,
    extensions: .add9
)

// Create slash chords
let cOverG = Chord(
    root: .c,
    quality: .major,
    bass: .g
)

// Get chord notes
let notes = cMaj.notes(octave: 4)

// Work with voicings
let voicing = Voicing.drop2(chord: cMaj, octave: 4)
```

### Chord Progressions

```swift
// Create common progressions
let popProg = ChordProgression.pop_I_V_vi_IV(root: .c)
// C - G - Am - F

let jazzProg = ChordProgression.jazz_ii_V_I(root: .c)
// Dm7 - G7 - Cmaj7

let blues = ChordProgression.blues12Bar(root: .c)

// Transpose progressions
let transposed = popProg.transposed(to: .g)

// Get chords from progression
let chords = popProg.chords
```

### Intervals

```swift
let majorThird = Interval.majorThird
let perfectFifth = Interval.perfectFifth

// Get interval properties
majorThird.semitones      // 4
majorThird.quality        // .major
majorThird.number         // 3

// Invert intervals
let minorSixth = majorThird.inverted
```

### Rhythm and Tempo

```swift
// Work with note durations
let quarter = NoteDuration.quarter
let duration = quarter.relativeDuration  // 0.25

// Create tempo
let allegro = Tempo.allegro
let beatDuration = allegro.beatDuration

// Calculate note timing
let noteLength = allegro.duration(of: .quarter)

// Time signatures
let fourFour = TimeSignature.commonTime
let waltz = TimeSignature.waltzTime
```

### MIDI

```swift
// Create MIDI messages
let note = try MIDINote(60)      // Middle C
let velocity = MIDIVelocity.mf
let channel = MIDIChannel.channel1

let noteOn = MIDIMessage.noteOn(
    channel: channel,
    note: note,
    velocity: velocity
)

// Get raw MIDI bytes
let bytes = noteOn.bytes  // [0x90, 60, 80]

// Parse MIDI messages
let message = try MIDIMessage.parse([0x90, 60, 80])

// Create MIDI tracks
var track = MIDITrack(name: "Piano")
track.addNote(
    note,
    channel: channel,
    startTick: 0,
    duration: 480,
    velocity: velocity
)

// Create and encode MIDI files
var midiFile = MIDIFile(ticksPerQuarterNote: 480)
midiFile.addTrack(track)

let data = try midiFile.encode()

// Decode MIDI files
let decoded = try MIDIFile.decode(from: data)
```

## Module Organization

### Core
- **PitchClass**: The twelve chromatic pitch classes
- **NoteName**: Note names with accidentals (enharmonic spellings)
- **Note**: Pitch class + octave with MIDI and frequency support
- **Frequency**: Frequency conversion and cents calculation

### Intervals
- **IntervalQuality**: Perfect, major, minor, augmented, diminished
- **Interval**: Musical intervals with inversion support

### Scales
- **ScalePattern**: Scale interval patterns (major, minor, modes, etc.)
- **Scale**: Root + pattern with note generation

### Chords
- **ChordQuality**: Triad and seventh chord qualities
- **ChordExtension**: Add9, flat9, sharp11, etc.
- **Chord**: Root + quality + extensions + optional bass
- **Voicing**: Specific note arrangements (drop-2, drop-3, etc.)

### Progressions
- **RomanNumeral**: Roman numeral chord notation
- **ChordProgression**: Sequences of chords in a key

### Rhythm
- **NoteDuration**: Whole, half, quarter, eighth, etc.
- **Tempo**: BPM with duration calculations
- **TimeSignature**: Time signature with meter properties

### MIDI
- **MIDINote**: MIDI note numbers (0-127)
- **MIDIVelocity**: MIDI velocity (0-127) with dynamic markings
- **MIDIChannel**: MIDI channels (1-16)
- **MIDIMessage**: MIDI message encoding/decoding
- **MIDIEvent**: MIDI message + timing
- **MIDITrack**: Collection of MIDI events
- **MIDIFile**: Complete MIDI file with encoding/decoding

## Design Philosophy

This package follows modern Swift best practices:

- **Value types**: Structs and enums for most types
- **Protocol-oriented**: Composition over inheritance
- **Type safety**: Leveraging Swift's type system to prevent errors
- **Immutability**: Prefer `let` over `var`
- **Sendable**: Full concurrency support
- **Descriptive naming**: Clear, self-documenting APIs
- **Functional patterns**: Map, filter, reduce where appropriate

## Examples

### Generate a Major Scale

```swift
let scale = Scale(root: .c, pattern: .major)
let notes = scale.notes(from: 4, to: 4)
// [C4, D4, E4, F4, G4, A4, B4]
```

### Create a ii-V-I Progression

```swift
let progression = ChordProgression.jazz_ii_V_I(root: .c)
let chords = progression.chords
// [Dm7, G7, Cmaj7]
```

### Build a MIDI File

```swift
var track = MIDITrack(name: "Melody")
let notes: [UInt8] = [60, 62, 64, 65, 67]

for (index, noteValue) in notes.enumerated() {
    let tick = UInt32(index * 480)
    track.addNote(
        try MIDINote(noteValue),
        channel: .channel1,
        startTick: tick,
        duration: 480,
        velocity: .mf
    )
}

var file = MIDIFile()
file.addTrack(track)
let data = try file.encode()
```

## Contributing

Contributions are welcome! Please ensure all code:
- Follows Swift API Design Guidelines
- Includes tests for new functionality
- Maintains Swift 6 strict concurrency compliance
- Uses value types and protocol-oriented patterns

## Documentation

Full API documentation is available at [https://0xleif.github.io/swift-music/documentation/music/](https://0xleif.github.io/swift-music/documentation/music/)

## License

MIT License - See LICENSE file for details

## Credits

Created by [Leif](https://github.com/0xLeif) for the Swift music theory community.
