import Testing
@testable import Music

@Suite("Scales")
struct ScaleTests {
    // MARK: - Scale Pattern Tests

    @Test("Major scale pattern")
    func majorScalePattern() {
        let pattern = ScalePattern.major
        #expect(pattern.intervals == [0, 2, 4, 5, 7, 9, 11])
    }

    @Test("Natural minor scale pattern")
    func naturalMinorPattern() {
        let pattern = ScalePattern.naturalMinor
        #expect(pattern.intervals == [0, 2, 3, 5, 7, 8, 10])
    }

    @Test("Harmonic minor scale pattern")
    func harmonicMinorPattern() {
        let pattern = ScalePattern.harmonicMinor
        #expect(pattern.intervals == [0, 2, 3, 5, 7, 8, 11])
    }

    @Test("Melodic minor scale pattern")
    func melodicMinorPattern() {
        let pattern = ScalePattern.melodicMinor
        #expect(pattern.intervals == [0, 2, 3, 5, 7, 9, 11])
    }

    // MARK: - Mode Tests

    @Test("Dorian mode pattern")
    func dorianModePattern() {
        let pattern = ScalePattern.dorian
        // D to D on white keys: D E F G A B C
        #expect(pattern.intervals == [0, 2, 3, 5, 7, 9, 10])
    }

    @Test("Phrygian mode pattern")
    func phrygianModePattern() {
        let pattern = ScalePattern.phrygian
        #expect(pattern.intervals == [0, 1, 3, 5, 7, 8, 10])
    }

    @Test("Mixolydian mode pattern")
    func mixolydianModePattern() {
        let pattern = ScalePattern.mixolydian
        #expect(pattern.intervals == [0, 2, 4, 5, 7, 9, 10])
    }

    // MARK: - Scale Pitch Classes

    @Test("C major scale pitch classes")
    func cMajorPitchClasses() {
        let scale = Scale.cMajor
        #expect(scale.pitchClasses == [.c, .d, .e, .f, .g, .a, .b])
    }

    @Test("A minor scale pitch classes")
    func aMinorPitchClasses() {
        let scale = Scale.aMinor
        #expect(scale.pitchClasses == [.a, .b, .c, .d, .e, .f, .g])
    }

    @Test("G major scale pitch classes")
    func gMajorPitchClasses() {
        let scale = Scale.gMajor
        #expect(scale.pitchClasses == [.g, .a, .b, .c, .d, .e, .fSharp])
    }

    @Test("D minor scale pitch classes")
    func dMinorPitchClasses() {
        let scale = Scale(root: .d, pattern: .naturalMinor)
        #expect(scale.pitchClasses == [.d, .e, .f, .g, .a, .aSharp, .c])
    }

    // MARK: - Scale Contains

    @Test("Scale contains pitch class")
    func scaleContains() {
        let cMajor = Scale.cMajor

        #expect(cMajor.contains(.c))
        #expect(cMajor.contains(.d))
        #expect(cMajor.contains(.e))
        #expect(!cMajor.contains(.cSharp))
        #expect(!cMajor.contains(.fSharp))
    }

    // MARK: - Relative Scales

    @Test("Relative minor of C major")
    func relativMinorOfCMajor() {
        let cMajor = Scale.cMajor
        let relative = cMajor.relative

        #expect(relative != nil)
        #expect(relative?.root == .a)
        #expect(relative?.pattern == .naturalMinor)
    }

    @Test("Relative major of A minor")
    func relativeMajorOfAMinor() {
        let aMinor = Scale.aMinor
        let relative = aMinor.relative

        #expect(relative != nil)
        #expect(relative?.root == .c)
        #expect(relative?.pattern == .major)
    }

    @Test("Relative scale of mode returns nil")
    func relativeModeReturnsNil() {
        let dDorian = Scale(root: .d, pattern: .dorian)
        #expect(dDorian.relative == nil)
    }

    // MARK: - Parallel Scales

    @Test("Parallel minor of C major")
    func parallelMinorOfCMajor() {
        let cMajor = Scale.cMajor
        let parallel = cMajor.parallel

        #expect(parallel != nil)
        #expect(parallel?.root == .c)
        #expect(parallel?.pattern == .naturalMinor)
    }

    @Test("Parallel major of C minor")
    func parallelMajorOfCMinor() {
        let cMinor = Scale(root: .c, pattern: .naturalMinor)
        let parallel = cMinor.parallel

        #expect(parallel != nil)
        #expect(parallel?.root == .c)
        #expect(parallel?.pattern == .major)
    }

    // MARK: - Note Generation

    @Test("Scale notes in octave range")
    func scaleNotesInRange() {
        let cMajor = Scale.cMajor
        let notes = cMajor.notes(from: 4, to: 4)

        #expect(notes.count == 7)
        #expect(notes[0].pitchClass == .c)
        #expect(notes[0].octave == 4)
    }

    @Test("Scale notes across multiple octaves")
    func scaleNotesMultipleOctaves() {
        let cMajor = Scale.cMajor
        let notes = cMajor.notes(from: 4, to: 5)

        #expect(notes.count == 14) // 7 notes per octave
    }

    @Test("Scale notes from start note")
    func scaleNotesFromStartNote() {
        let cMajor = Scale.cMajor
        let startNote = Note(pitchClass: .c, octave: 4)
        let notes = cMajor.notes(from: startNote, count: 8)

        #expect(notes.count == 8)
        #expect(notes.first == startNote)
        #expect(notes.last?.pitchClass == .c)
        #expect(notes.last?.octave == 5)
    }

    // MARK: - Display Name

    @Test("Scale display name")
    func scaleDisplayName() {
        #expect(Scale.cMajor.displayName == "C Major")
        #expect(Scale.aMinor.displayName == "A Natural Minor")
    }

    // MARK: - Equality and Hashing

    @Test("Scale equality")
    func scaleEquality() {
        let c1 = Scale(root: .c, pattern: .major)
        let c2 = Scale(root: .c, pattern: .major)
        let d = Scale(root: .d, pattern: .major)

        #expect(c1 == c2)
        #expect(c1 != d)
    }

    @Test("Scale hashable")
    func scaleHashable() {
        var set = Set<Scale>()
        set.insert(Scale.cMajor)
        set.insert(Scale.cMajor)
        set.insert(Scale.aMinor)

        #expect(set.count == 2)
    }

    // MARK: - Pentatonic Scales

    @Test("Major pentatonic scale")
    func majorPentatonicScale() {
        let cPentatonic = Scale(root: .c, pattern: .majorPentatonic)
        #expect(cPentatonic.pitchClasses.count == 5)
        #expect(cPentatonic.pitchClasses == [.c, .d, .e, .g, .a])
    }

    @Test("Minor pentatonic scale")
    func minorPentatonicScale() {
        let aPentatonic = Scale(root: .a, pattern: .minorPentatonic)
        #expect(aPentatonic.pitchClasses.count == 5)
        #expect(aPentatonic.pitchClasses == [.a, .c, .d, .e, .g])
    }

    // MARK: - Blues Scale

    @Test("Blues scale")
    func bluesScale() {
        let aBlues = Scale(root: .a, pattern: .blues)
        #expect(aBlues.pitchClasses.count == 6)
    }

    // MARK: - Chromatic Scale

    @Test("Chromatic scale")
    func chromaticScale() {
        let chromatic = Scale(root: .c, pattern: .chromatic)
        #expect(chromatic.pitchClasses.count == 12)
    }
}
