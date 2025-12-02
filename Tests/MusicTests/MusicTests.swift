import Testing
@testable import Music

@Suite("Music")
struct MusicTests {
    @Test("Pitch class transposition")
    func pitchClassTransposition() {
        let c = PitchClass.c
        let d = c.transposed(by: 2)
        #expect(d == .d)

        let e = c.transposed(by: 4)
        #expect(e == .e)
    }

    @Test("Note creation")
    func noteCreation() {
        let middleC = Note.middleC
        #expect(middleC.midiNumber == 60)
        #expect(middleC.pitchClass == .c)
        #expect(middleC.octave == 4)
    }

    @Test("Frequency calculation")
    func frequencyCalculation() {
        let a440Frequency = Frequency.fromMIDI(69)
        #expect(abs(a440Frequency - 440.0) < 0.01)
    }

    @Test("Scale generation")
    func scaleGeneration() {
        let cMajor = Scale.cMajor
        let pitchClasses = cMajor.pitchClasses
        #expect(pitchClasses == [.c, .d, .e, .f, .g, .a, .b])
    }

    @Test("Chord creation")
    func chordCreation() {
        let cMajor = Chord.cMajor
        let pitchClasses = cMajor.pitchClasses
        #expect(pitchClasses == [.c, .e, .g])
    }

    @Test("Chord progression")
    func chordProgression() {
        let progression = ChordProgression.pop_I_V_vi_IV(root: .c)
        let chords = progression.chords
        #expect(chords.count == 4)
        #expect(chords[0].root == .c)
        #expect(chords[1].root == .g)
        #expect(chords[2].root == .a)
        #expect(chords[3].root == .f)
    }

    @Test("MIDI message encoding")
    func midiMessageEncoding() throws {
        let note = try MIDINote(60)
        let velocity = try MIDIVelocity(100)
        let channel = try MIDIChannel(0)

        let message = MIDIMessage.noteOn(
            channel: channel,
            note: note,
            velocity: velocity
        )

        let bytes = message.bytes
        #expect(bytes == [0x90, 60, 100])
    }

    @Test("MIDI message parsing")
    func midiMessageParsing() throws {
        let bytes: [UInt8] = [0x90, 60, 100]
        let message = try MIDIMessage.parse(bytes)

        if case .noteOn(let channel, let note, let velocity) = message {
            #expect(channel.value == 0)
            #expect(note.value == 60)
            #expect(velocity.value == 100)
        } else {
            Issue.record("Expected note on message")
        }
    }
}
