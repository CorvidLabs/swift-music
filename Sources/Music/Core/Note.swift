/**
 Represents a musical note with a specific pitch class and octave

 A note combines a pitch class with an octave number to define
 an absolute pitch in the musical spectrum.
 */
public struct Note: Sendable {
    /// The pitch class of the note
    public let pitchClass: PitchClass

    /// The octave number (middle C is octave 4)
    public let octave: Int

    /**
     Creates a note with a pitch class and octave

     - Parameters:
       - pitchClass: The pitch class
       - octave: The octave number
     */
    public init(pitchClass: PitchClass, octave: Int) {
        self.pitchClass = pitchClass
        self.octave = octave
    }

    /// The MIDI note number (0-127)
    public var midiNumber: Int {
        (octave + 1) * 12 + pitchClass.rawValue
    }

    /// The frequency in Hz using equal temperament with A4 = 440 Hz
    public var frequency: Double {
        Frequency.fromMIDI(midiNumber)
    }

    /**
     Transposes this note by a given number of semitones

     - Parameter semitones: The number of semitones to transpose
     - Returns: The transposed note
     */
    public func transposed(by semitones: Int) -> Note {
        let newMIDI = midiNumber + semitones
        return Note.fromMIDI(newMIDI)
    }

    /**
     Creates a note from a MIDI note number

     - Parameter midiNumber: The MIDI note number (0-127)
     - Returns: The corresponding note
     */
    public static func fromMIDI(_ midiNumber: Int) -> Note {
        let octave = (midiNumber / 12) - 1
        let pitchClass = PitchClass(rawValue: midiNumber % 12)!
        return Note(pitchClass: pitchClass, octave: octave)
    }

    /// Creates middle C (C4)
    public static let middleC = Note(pitchClass: .c, octave: 4)

    /// Creates A440 (A4)
    public static let a440 = Note(pitchClass: .a, octave: 4)
}

extension Note: Equatable {
    public static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.midiNumber == rhs.midiNumber
    }
}

extension Note: Comparable {
    public static func < (lhs: Note, rhs: Note) -> Bool {
        lhs.midiNumber < rhs.midiNumber
    }
}

extension Note: CustomStringConvertible {
    public var description: String {
        "\(pitchClass.displayName)\(octave)"
    }
}

extension Note: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(midiNumber)
    }
}
