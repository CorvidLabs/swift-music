import Testing
@testable import Music

@Suite("Chords")
struct ChordTests {
    // MARK: - Basic Chord Tests

    @Test("Major chord pitch classes")
    func majorChordPitchClasses() {
        let cMajor = Chord(root: .c, quality: .major)
        #expect(cMajor.pitchClasses == [.c, .e, .g])

        let gMajor = Chord(root: .g, quality: .major)
        #expect(gMajor.pitchClasses == [.g, .b, .d])
    }

    @Test("Minor chord pitch classes")
    func minorChordPitchClasses() {
        let aMinor = Chord(root: .a, quality: .minor)
        #expect(aMinor.pitchClasses == [.a, .c, .e])

        let dMinor = Chord(root: .d, quality: .minor)
        #expect(dMinor.pitchClasses == [.d, .f, .a])
    }

    @Test("Diminished chord pitch classes")
    func diminishedChordPitchClasses() {
        let bDim = Chord(root: .b, quality: .diminished)
        #expect(bDim.pitchClasses == [.b, .d, .f])
    }

    @Test("Augmented chord pitch classes")
    func augmentedChordPitchClasses() {
        let cAug = Chord(root: .c, quality: .augmented)
        #expect(cAug.pitchClasses == [.c, .e, .gSharp])
    }

    // MARK: - Seventh Chord Tests

    @Test("Major 7th chord pitch classes")
    func major7ChordPitchClasses() {
        let cMaj7 = Chord(root: .c, quality: .major7)
        #expect(cMaj7.pitchClasses == [.c, .e, .g, .b])
    }

    @Test("Minor 7th chord pitch classes")
    func minor7ChordPitchClasses() {
        let aMin7 = Chord(root: .a, quality: .minor7)
        #expect(aMin7.pitchClasses == [.a, .c, .e, .g])
    }

    @Test("Dominant 7th chord pitch classes")
    func dominant7ChordPitchClasses() {
        let g7 = Chord(root: .g, quality: .dominant7)
        #expect(g7.pitchClasses == [.g, .b, .d, .f])
    }

    @Test("Half-diminished chord pitch classes")
    func halfDiminishedChordPitchClasses() {
        let bHalfDim = Chord(root: .b, quality: .halfDiminished7)
        #expect(bHalfDim.pitchClasses == [.b, .d, .f, .a])
    }

    @Test("Diminished 7th chord pitch classes")
    func diminished7ChordPitchClasses() {
        let bDim7 = Chord(root: .b, quality: .diminished7)
        // B, D, F, Ab
        #expect(bDim7.pitchClasses.count == 4)
        #expect(bDim7.pitchClasses[0] == .b)
        #expect(bDim7.pitchClasses[1] == .d)
        #expect(bDim7.pitchClasses[2] == .f)
    }

    // MARK: - Chord Inversions

    @Test("First inversion")
    func firstInversion() {
        let cMajor = Chord(root: .c, quality: .major)
        let firstInv = cMajor.inversion(1)

        #expect(firstInv.root == .c)
        #expect(firstInv.bass == .e)
    }

    @Test("Second inversion")
    func secondInversion() {
        let cMajor = Chord(root: .c, quality: .major)
        let secondInv = cMajor.inversion(2)

        #expect(secondInv.root == .c)
        #expect(secondInv.bass == .g)
    }

    @Test("Root position unchanged")
    func rootPosition() {
        let cMajor = Chord(root: .c, quality: .major)
        let rootPos = cMajor.inversion(0)

        #expect(rootPos == cMajor)
        #expect(rootPos.bass == nil)
    }

    // MARK: - Slash Chords

    @Test("Slash chord with different bass")
    func slashChord() {
        let cOverG = Chord(root: .c, quality: .major, bass: .g)

        #expect(cOverG.pitchClasses.first == .g)
        #expect(cOverG.symbol.contains("/G"))
    }

    @Test("Slash chord with same bass as root")
    func slashChordSameBass() {
        let cOverC = Chord(root: .c, quality: .major, bass: .c)

        // Bass same as root shouldn't duplicate
        #expect(cOverC.pitchClasses == [.c, .e, .g])
    }

    // MARK: - Extensions

    @Test("Chord with add9")
    func chordWithAdd9() {
        let cAdd9 = Chord(root: .c, quality: .major, extensions: .add9)
        let pitches = cAdd9.pitchClasses

        #expect(pitches.contains(.c))
        #expect(pitches.contains(.e))
        #expect(pitches.contains(.g))
        #expect(pitches.contains(.d)) // 9th = D
    }

    @Test("Chord with multiple extensions")
    func chordWithMultipleExtensions() {
        let c7add9 = Chord(root: .c, quality: .dominant7, extensions: [.add9])

        #expect(c7add9.pitchClasses.count >= 5)
    }

    // MARK: - Note Generation

    @Test("Chord notes in octave")
    func chordNotesInOctave() {
        let cMajor = Chord(root: .c, quality: .major)
        let notes = cMajor.notes(octave: 4)

        #expect(notes.count == 3)
        #expect(notes[0].pitchClass == .c)
        #expect(notes[0].octave == 4)
        #expect(notes[1].pitchClass == .e)
        #expect(notes[2].pitchClass == .g)
    }

    @Test("Seventh chord notes span octaves")
    func seventhChordNotes() {
        let cMaj7 = Chord(root: .c, quality: .major7)
        let notes = cMaj7.notes(octave: 4)

        #expect(notes.count == 4)
    }

    // MARK: - Voicing Tests

    @Test("Close voicing")
    func closeVoicing() {
        let chord = Chord(root: .c, quality: .major7)
        let startNote = Note(pitchClass: .c, octave: 4)
        let voicing = Voicing.close(chord: chord, startNote: startNote)

        #expect(voicing.notes.count == 4)
        #expect(voicing.lowestNote?.pitchClass == .c)
    }

    @Test("Drop-2 voicing")
    func drop2Voicing() {
        let chord = Chord(root: .c, quality: .major7)
        let voicing = Voicing.drop2(chord: chord, octave: 4)

        #expect(voicing.notes.count == 4)
        // Second highest note should be dropped an octave
        #expect(voicing.range > 12)
    }

    @Test("Drop-3 voicing")
    func drop3Voicing() {
        let chord = Chord(root: .c, quality: .major7)
        let voicing = Voicing.drop3(chord: chord, octave: 4)

        #expect(voicing.notes.count == 4)
        #expect(voicing.range > 12)
    }

    @Test("Voicing with triad returns unchanged")
    func voicingTriad() {
        let chord = Chord(root: .c, quality: .major)
        let drop2 = Voicing.drop2(chord: chord, octave: 4)

        // Triads don't have enough notes for drop voicings
        #expect(drop2.notes.count == 3)
    }

    @Test("Voicing range calculation")
    func voicingRange() {
        let chord = Chord(root: .c, quality: .major)
        let voicing = Voicing.close(chord: chord, startNote: Note(pitchClass: .c, octave: 4))

        // C4 to G4 = 7 semitones
        #expect(voicing.range == 7)
    }

    // MARK: - Chord Symbols

    @Test("Chord symbol display")
    func chordSymbol() {
        #expect(Chord.cMajor.symbol == "C")
        #expect(Chord.cMinor.symbol.contains("m"))
        #expect(Chord.g7.symbol.contains("7"))
    }

    // MARK: - Equality and Hashing

    @Test("Chord equality")
    func chordEquality() {
        let c1 = Chord(root: .c, quality: .major)
        let c2 = Chord(root: .c, quality: .major)
        let d = Chord(root: .d, quality: .major)

        #expect(c1 == c2)
        #expect(c1 != d)
    }

    @Test("Chord hashable")
    func chordHashable() {
        var set = Set<Chord>()
        set.insert(Chord.cMajor)
        set.insert(Chord.cMajor)
        set.insert(Chord.gMajor)

        #expect(set.count == 2)
    }
}
