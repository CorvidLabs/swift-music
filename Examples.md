# swift-music Examples

## Table of Contents
- [Basic Notes and Scales](#basic-notes-and-scales)
- [Chord Construction](#chord-construction)
- [Progressions](#progressions)
- [MIDI Creation](#midi-creation)
- [Advanced Examples](#advanced-examples)

## Basic Notes and Scales

### Working with Pitch Classes

```swift
import Music

// Transpose pitch classes
let c = PitchClass.c
let d = c.transposed(by: 2)
let g = c.transposed(by: 7)

// Calculate distances
let distance = c.distance(to: g)  // 7 semitones
```

### Creating Notes

```swift
// Create notes with pitch class and octave
let middleC = Note(pitchClass: .c, octave: 4)
let note = Note.fromMIDI(60)  // Also middle C

// Get note properties
print(middleC.midiNumber)    // 60
print(middleC.frequency)     // ~261.63 Hz
```

### Building Scales

```swift
// Major scale
let cMajor = Scale(root: .c, pattern: .major)
let pitchClasses = cMajor.pitchClasses
// [C, D, E, F, G, A, B]

// Get all notes in a scale across octaves
let notes = cMajor.notes(from: 3, to: 5)

// Modal scales
let dDorian = Scale(root: .d, pattern: .dorian)
let ePhrygian = Scale(root: .e, pattern: .phrygian)

// Pentatonic and blues
let cMinorPentatonic = Scale(root: .c, pattern: .minorPentatonic)
let eBlues = Scale(root: .e, pattern: .blues)
```

## Chord Construction

### Basic Triads

```swift
// Major, minor, diminished, augmented
let cMajor = Chord(root: .c, quality: .major)
let dMinor = Chord(root: .d, quality: .minor)
let bdim = Chord(root: .b, quality: .diminished)
let caug = Chord(root: .c, quality: .augmented)

// Get chord notes
let notes = cMajor.notes(octave: 4)
// [C4, E4, G4]
```

### Seventh Chords

```swift
let cmaj7 = Chord(root: .c, quality: .major7)
let dm7 = Chord(root: .d, quality: .minor7)
let g7 = Chord(root: .g, quality: .dominant7)
let bm7b5 = Chord(root: .b, quality: .halfDiminished7)
```

### Extended Chords

```swift
// Add extensions
let dm9 = Chord(
    root: .d,
    quality: .minor7,
    extensions: .add9
)

let g7sharp11 = Chord(
    root: .g,
    quality: .dominant7,
    extensions: .sharp11
)

// Multiple extensions
let complex = Chord(
    root: .c,
    quality: .dominant7,
    extensions: [.flat9, .sharp11]
)
```

### Slash Chords

```swift
// Create inversions with bass notes
let cOverE = Chord(
    root: .c,
    quality: .major,
    bass: .e  // First inversion
)

let cOverG = Chord(
    root: .c,
    quality: .major,
    bass: .g  // Second inversion
)
```

### Voicings

```swift
let chord = Chord(root: .c, quality: .major7)

// Close voicing
let close = Voicing.close(chord: chord, startNote: Note(pitchClass: .c, octave: 4))

// Drop-2 voicing (jazz guitar/piano)
let drop2 = Voicing.drop2(chord: chord, octave: 4)

// Drop-3 voicing
let drop3 = Voicing.drop3(chord: chord, octave: 4)
```

## Progressions

### Common Pop Progressions

```swift
// I - V - vi - IV (very common in pop)
let popProg = ChordProgression.pop_I_V_vi_IV(root: .c)
let chords = popProg.chords
// [C, G, Am, F]

// I - vi - IV - V (50s progression)
let fifties = ChordProgression.fifties_I_vi_IV_V(root: .c)
// [C, Am, F, G]

// I - IV - V (basic rock)
let basic = ChordProgression.major_I_IV_V(root: .g)
// [G, C, D]
```

### Jazz Progressions

```swift
// ii - V - I (the most important jazz progression)
let ii_V_I = ChordProgression.jazz_ii_V_I(root: .c)
// [Dm7, G7, Cmaj7]

// Transpose to different keys
let inF = ii_V_I.transposed(to: .f)
// [Gm7, C7, Fmaj7]
```

### Blues Progressions

```swift
// 12-bar blues
let blues = ChordProgression.blues12Bar(root: .a)
// [A7, A7, A7, A7, D7, D7, A7, A7, E7, D7, A7, E7]
```

### Custom Progressions

```swift
// Build custom progressions with Roman numerals
let progression = ChordProgression(
    scale: Scale(root: .c, pattern: .major),
    numerals: [
        .majorI,
        .minorIII,
        .majorIV,
        .dominantV7
    ]
)
```

## MIDI Creation

### Basic MIDI Messages

```swift
// Create MIDI note
let note = try MIDINote(60)  // Middle C
let velocity = MIDIVelocity.mf  // Mezzo-forte
let channel = MIDIChannel.channel1

// Create note on/off messages
let noteOn = MIDIMessage.noteOn(
    channel: channel,
    note: note,
    velocity: velocity
)

let noteOff = MIDIMessage.noteOff(
    channel: channel,
    note: note
)

// Get raw MIDI bytes
let bytes = noteOn.bytes  // [0x90, 60, 80]
```

### Building MIDI Tracks

```swift
var track = MIDITrack(name: "Piano")

// Add individual notes
track.addNote(
    try MIDINote(60),
    channel: .channel1,
    startTick: 0,
    duration: 480,
    velocity: .mf
)

track.addNote(
    try MIDINote(64),
    channel: .channel1,
    startTick: 480,
    duration: 480,
    velocity: .f
)

track.addNote(
    try MIDINote(67),
    channel: .channel1,
    startTick: 960,
    duration: 480,
    velocity: .mf
)

// Sort events by time
track.sort()
```

### Creating MIDI Files

```swift
// Create a MIDI file
var midiFile = MIDIFile(
    format: .multiTrack,
    ticksPerQuarterNote: 480
)

// Add multiple tracks
var melody = MIDITrack(name: "Melody")
var harmony = MIDITrack(name: "Harmony")

// ... add notes to tracks ...

midiFile.addTrack(melody)
midiFile.addTrack(harmony)

// Encode to data
let data = try midiFile.encode()

// Save to file
try data.write(to: URL(fileURLWithPath: "output.mid"))
```

### Reading MIDI Files

```swift
// Load from file
let data = try Data(contentsOf: URL(fileURLWithPath: "input.mid"))

// Decode
let midiFile = try MIDIFile.decode(from: data)

// Access tracks
for track in midiFile.tracks {
    print("Track: \(track.name)")
    print("Events: \(track.events.count)")
}
```

## Advanced Examples

### Generate a Scale Pattern as MIDI

```swift
func createScaleMIDI(scale: Scale, octave: Int) throws -> MIDITrack {
    var track = MIDITrack(name: "\(scale.displayName) Scale")
    let notes = scale.notes(from: octave, to: octave)

    for (index, note) in notes.enumerated() {
        let tick = UInt32(index * 240)  // Quarter note at 480 TPQN
        track.addNote(
            try MIDINote(UInt8(note.midiNumber)),
            channel: .channel1,
            startTick: tick,
            duration: 240,
            velocity: .mf
        )
    }

    return track
}

let cMajorTrack = try createScaleMIDI(
    scale: Scale(root: .c, pattern: .major),
    octave: 4
)
```

### Generate a Chord Progression as MIDI

```swift
func createProgressionMIDI(progression: ChordProgression) throws -> MIDITrack {
    var track = MIDITrack(name: "Progression")
    let chords = progression.chords

    for (index, chord) in chords.enumerated() {
        let startTick = UInt32(index * 1920)  // One measure at 480 TPQN
        let notes = chord.notes(octave: 4)

        // Play all notes in chord simultaneously
        for note in notes {
            track.addNote(
                try MIDINote(UInt8(note.midiNumber)),
                channel: .channel1,
                startTick: startTick,
                duration: 1920,
                velocity: .mf
            )
        }
    }

    return track
}

let progression = ChordProgression.jazz_ii_V_I(root: .c)
let track = try createProgressionMIDI(progression: progression)
```

### Analyze Frequency

```swift
// Convert frequency to note
let frequency = 432.0  // Hz
let note = Frequency.toNote(frequency)
print(note)  // A4 (approximately)

// Check cents deviation from equal temperament
let deviation = Frequency.centsDeviation(frequency)
print("Off by \(deviation) cents")  // ~-31.8 cents

// Calculate interval in cents
let cents = Frequency.cents(from: 440.0, to: 880.0)
print(cents)  // 1200 cents (one octave)
```

### Working with Tempo

```swift
let tempo = Tempo(bpm: 120)

// Get beat duration
let beatDuration = tempo.beatDuration  // 0.5 seconds

// Calculate note durations
let quarterDuration = tempo.duration(of: .quarter)
let eighthDuration = tempo.duration(of: .eighth)
let dottedQuarter = tempo.duration(relativeDuration: NoteDuration.quarter.dotted)

// Use tempo markings
let allegro = TempoMarking.allegro.typicalTempo
print(allegro.bpm)  // ~130 BPM
```

### Complex Voicing Example

```swift
// Create a jazz voicing for a ii-V-I
let dm7 = Chord(root: .d, quality: .minor7)
let g7 = Chord(root: .g, quality: .dominant7, extensions: [.flat9, .sharp11])
let cmaj7 = Chord(root: .c, quality: .major7)

// Use drop-2 voicings throughout
let voicing1 = Voicing.drop2(chord: dm7, octave: 4)
let voicing2 = Voicing.drop2(chord: g7, octave: 4)
let voicing3 = Voicing.drop2(chord: cmaj7, octave: 4)

// Create MIDI from voicings
var track = MIDITrack(name: "Jazz Piano")
for (index, voicing) in [voicing1, voicing2, voicing3].enumerated() {
    let startTick = UInt32(index * 1920)
    for note in voicing.notes {
        track.addNote(
            try MIDINote(UInt8(note.midiNumber)),
            channel: .channel1,
            startTick: startTick,
            duration: 1920,
            velocity: .mp
        )
    }
}
```

### Modal Interchange

```swift
// Start with C major
let cMajor = Scale(root: .c, pattern: .major)

// Borrow chords from parallel minor
let cMinor = cMajor.parallel!

// Create progression with modal interchange
let progression = ChordProgression(
    scale: cMajor,
    numerals: [
        .majorI,              // C
        .majorIV,             // F (from C major)
        RomanNumeral(degree: 4, quality: .minor),  // Fm (from C minor)
        .majorV               // G
    ]
)
```
