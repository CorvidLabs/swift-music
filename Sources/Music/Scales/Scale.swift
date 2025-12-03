/**
 Represents a musical scale with a specific root note and pattern

 A scale combines a root pitch class with a scale pattern to define
 a specific collection of pitches.
 */
public struct Scale: Sendable {
    /// The root pitch class of the scale
    public let root: PitchClass

    /// The pattern of intervals that defines the scale
    public let pattern: ScalePattern

    /**
     Creates a scale with a root and pattern

     - Parameters:
       - root: The root pitch class
       - pattern: The scale pattern
     */
    public init(root: PitchClass, pattern: ScalePattern) {
        self.root = root
        self.pattern = pattern
    }

    /// The pitch classes in this scale
    public var pitchClasses: [PitchClass] {
        pattern.intervals.map { semitones in
            root.transposed(by: semitones)
        }
    }

    /**
     Generates notes in this scale for a given octave range

     - Parameters:
       - startOctave: The starting octave
       - endOctave: The ending octave (inclusive)
     - Returns: Array of notes in the scale
     */
    public func notes(from startOctave: Int, to endOctave: Int) -> [Note] {
        var notes: [Note] = []

        for octave in startOctave...endOctave {
            for interval in pattern.intervals {
                let pitchClass = root.transposed(by: interval)
                let note = Note(pitchClass: pitchClass, octave: octave)
                notes.append(note)
            }
        }

        return notes.sorted()
    }

    /**
     Generates notes in this scale starting from a specific note

     - Parameters:
       - startNote: The starting note
       - count: The number of notes to generate
     - Returns: Array of notes in the scale
     */
    public func notes(from startNote: Note, count: Int) -> [Note] {
        var notes: [Note] = []
        var currentOctave = startNote.octave
        var noteIndex = 0

        while notes.count < count {
            let interval = pattern.intervals[noteIndex % pattern.intervals.count]
            let pitchClass = root.transposed(by: interval)
            let note = Note(pitchClass: pitchClass, octave: currentOctave)

            if note >= startNote {
                notes.append(note)
            }

            noteIndex += 1
            if noteIndex % pattern.intervals.count == 0 {
                currentOctave += 1
            }
        }

        return notes
    }

    /**
     Checks if a pitch class is in this scale

     - Parameter pitchClass: The pitch class to check
     - Returns: True if the pitch class is in the scale
     */
    public func contains(_ pitchClass: PitchClass) -> Bool {
        pitchClasses.contains(pitchClass)
    }

    /**
     Returns the relative major or minor scale

     For minor scales, returns the relative major.
     For major scales, returns the relative minor.
     */
    public var relative: Scale? {
        switch pattern {
        case .major:
            let relativeRoot = root.transposed(by: 9) // major 6th up
            return Scale(root: relativeRoot, pattern: .naturalMinor)
        case .naturalMinor:
            let relativeRoot = root.transposed(by: 3) // minor 3rd up
            return Scale(root: relativeRoot, pattern: .major)
        default:
            return nil
        }
    }

    /**
     Returns the parallel major or minor scale

     A parallel scale shares the same root but has a different quality.
     */
    public var parallel: Scale? {
        switch pattern {
        case .major:
            return Scale(root: root, pattern: .naturalMinor)
        case .naturalMinor:
            return Scale(root: root, pattern: .major)
        default:
            return nil
        }
    }

    /// Display name of the scale
    public var displayName: String {
        "\(root.displayName) \(pattern.name)"
    }

    // MARK: - Common Scales

    /// C Major scale
    public static let cMajor = Scale(root: .c, pattern: .major)

    /// A Minor scale
    public static let aMinor = Scale(root: .a, pattern: .naturalMinor)

    /// G Major scale
    public static let gMajor = Scale(root: .g, pattern: .major)

    /// E Minor scale
    public static let eMinor = Scale(root: .e, pattern: .naturalMinor)
}

extension Scale: Equatable {
    public static func == (lhs: Scale, rhs: Scale) -> Bool {
        lhs.root == rhs.root && lhs.pattern == rhs.pattern
    }
}

extension Scale: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(root)
        hasher.combine(pattern)
    }
}

extension Scale: CustomStringConvertible {
    public var description: String {
        displayName
    }
}
