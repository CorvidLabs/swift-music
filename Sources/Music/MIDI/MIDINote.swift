/**
 Represents a MIDI note number (0-127)

 MIDI notes range from 0 (C-1) to 127 (G9).
 */
public struct MIDINote: Sendable {
    /// The MIDI note number (0-127)
    public let value: UInt8

    /**
     Creates a MIDI note

     - Parameter value: The MIDI note number (0-127)
     - Throws: MusicError.invalidMIDI if the value is out of range
     */
    public init(_ value: UInt8) throws {
        guard value <= 127 else {
            throw MusicError.invalidMIDI("MIDI note must be 0-127, got \(value)")
        }
        self.value = value
    }

    /**
     Creates a MIDI note from an integer (clamped to 0-127)

     - Parameter value: The MIDI note number
     */
    public init(clamped value: Int) {
        self.value = UInt8(max(0, min(127, value)))
    }

    /**
     Creates a MIDI note, returning nil if out of range

     - Parameter value: The MIDI note number
     */
    public init?(unchecked value: UInt8) {
        guard value <= 127 else {
            return nil
        }
        self.value = value
    }

    /// The corresponding Note
    public var note: Note {
        Note.fromMIDI(Int(value))
    }

    /// Middle C (MIDI note 60)
    public static let middleC = try! MIDINote(60)

    /// A440 (MIDI note 69)
    public static let a440 = try! MIDINote(69)
}

extension MIDINote: Equatable {
    public static func == (lhs: MIDINote, rhs: MIDINote) -> Bool {
        lhs.value == rhs.value
    }
}

extension MIDINote: Comparable {
    public static func < (lhs: MIDINote, rhs: MIDINote) -> Bool {
        lhs.value < rhs.value
    }
}

extension MIDINote: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension MIDINote: CustomStringConvertible {
    public var description: String {
        "\(note.description) (MIDI \(value))"
    }
}
