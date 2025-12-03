/**
 Represents a specific voicing of a chord

 A voicing defines the exact arrangement and spacing of notes
 in a chord across different octaves.
 */
public struct Voicing: Sendable {
    /// The notes in this voicing, ordered from lowest to highest
    public let notes: [Note]

    /**
     Creates a voicing with specific notes

     - Parameter notes: The notes in the voicing
     */
    public init(notes: [Note]) {
        self.notes = notes.sorted()
    }

    /**
     Creates a voicing from a chord and starting note

     - Parameters:
       - chord: The chord to voice
       - startNote: The lowest note in the voicing
     - Returns: A close voicing starting from the given note
     */
    public static func close(chord: Chord, startNote: Note) -> Voicing {
        let chordNotes = chord.notes(octave: startNote.octave)
        let adjustedNotes = chordNotes.map { note in
            if note < startNote {
                return note.transposed(by: 12)
            }
            return note
        }
        return Voicing(notes: adjustedNotes)
    }

    /**
     Creates a drop-2 voicing from a chord

     Drop-2 voicing takes the second-highest note and drops it an octave.

     - Parameters:
       - chord: The chord to voice
       - octave: The base octave
     - Returns: A drop-2 voicing
     */
    public static func drop2(chord: Chord, octave: Int) -> Voicing {
        var notes = chord.notes(octave: octave).sorted()

        guard notes.count >= 4 else {
            return Voicing(notes: notes)
        }

        // Drop the second-highest note an octave
        let dropIndex = notes.count - 2
        notes[dropIndex] = notes[dropIndex].transposed(by: -12)

        return Voicing(notes: notes.sorted())
    }

    /**
     Creates a drop-3 voicing from a chord

     Drop-3 voicing takes the third-highest note and drops it an octave.

     - Parameters:
       - chord: The chord to voice
       - octave: The base octave
     - Returns: A drop-3 voicing
     */
    public static func drop3(chord: Chord, octave: Int) -> Voicing {
        var notes = chord.notes(octave: octave).sorted()

        guard notes.count >= 4 else {
            return Voicing(notes: notes)
        }

        // Drop the third-highest note an octave
        let dropIndex = notes.count - 3
        notes[dropIndex] = notes[dropIndex].transposed(by: -12)

        return Voicing(notes: notes.sorted())
    }

    /**
     Creates a drop-2-4 voicing from a chord

     Drop-2-4 voicing drops both the second and fourth notes from the top.

     - Parameters:
       - chord: The chord to voice
       - octave: The base octave
     - Returns: A drop-2-4 voicing
     */
    public static func drop24(chord: Chord, octave: Int) -> Voicing {
        var notes = chord.notes(octave: octave).sorted()

        guard notes.count >= 4 else {
            return Voicing(notes: notes)
        }

        // Drop the second and fourth notes from the top
        notes[notes.count - 2] = notes[notes.count - 2].transposed(by: -12)
        notes[notes.count - 4] = notes[notes.count - 4].transposed(by: -12)

        return Voicing(notes: notes.sorted())
    }

    /// The range of the voicing (distance from lowest to highest note)
    public var range: Int {
        guard let lowest = notes.first, let highest = notes.last else {
            return 0
        }
        return highest.midiNumber - lowest.midiNumber
    }

    /// The lowest note in the voicing
    public var lowestNote: Note? {
        notes.first
    }

    /// The highest note in the voicing
    public var highestNote: Note? {
        notes.last
    }
}

extension Voicing: Equatable {
    public static func == (lhs: Voicing, rhs: Voicing) -> Bool {
        lhs.notes == rhs.notes
    }
}

extension Voicing: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(notes)
    }
}

extension Voicing: CustomStringConvertible {
    public var description: String {
        "[\(notes.map { $0.description }.joined(separator: ", "))]"
    }
}
