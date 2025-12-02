/// Represents a scale pattern as a sequence of intervals
///
/// A scale pattern defines the structure of a scale independent
/// of its root note.
public struct ScalePattern: Sendable {
    /// The intervals that make up this scale pattern (in semitones from root)
    public let intervals: [Int]

    /// The name of the scale pattern
    public let name: String

    /// Creates a scale pattern with intervals and a name
    /// - Parameters:
    ///   - intervals: Array of semitone intervals from the root
    ///   - name: The name of the scale pattern
    public init(intervals: [Int], name: String) {
        self.intervals = intervals
        self.name = name
    }

    /// The number of notes in this scale
    public var noteCount: Int {
        intervals.count
    }

    // MARK: - Major Scale and Modes

    /// Major scale (Ionian mode): W-W-H-W-W-W-H
    public static let major = ScalePattern(
        intervals: [0, 2, 4, 5, 7, 9, 11],
        name: "Major"
    )

    /// Natural minor scale (Aeolian mode): W-H-W-W-H-W-W
    public static let naturalMinor = ScalePattern(
        intervals: [0, 2, 3, 5, 7, 8, 10],
        name: "Natural Minor"
    )

    /// Harmonic minor scale: W-H-W-W-H-WH-H
    public static let harmonicMinor = ScalePattern(
        intervals: [0, 2, 3, 5, 7, 8, 11],
        name: "Harmonic Minor"
    )

    /// Melodic minor scale (ascending): W-H-W-W-W-W-H
    public static let melodicMinor = ScalePattern(
        intervals: [0, 2, 3, 5, 7, 9, 11],
        name: "Melodic Minor"
    )

    // MARK: - Modes

    /// Dorian mode: W-H-W-W-W-H-W
    public static let dorian = ScalePattern(
        intervals: [0, 2, 3, 5, 7, 9, 10],
        name: "Dorian"
    )

    /// Phrygian mode: H-W-W-W-H-W-W
    public static let phrygian = ScalePattern(
        intervals: [0, 1, 3, 5, 7, 8, 10],
        name: "Phrygian"
    )

    /// Lydian mode: W-W-W-H-W-W-H
    public static let lydian = ScalePattern(
        intervals: [0, 2, 4, 6, 7, 9, 11],
        name: "Lydian"
    )

    /// Mixolydian mode: W-W-H-W-W-H-W
    public static let mixolydian = ScalePattern(
        intervals: [0, 2, 4, 5, 7, 9, 10],
        name: "Mixolydian"
    )

    /// Locrian mode: H-W-W-H-W-W-W
    public static let locrian = ScalePattern(
        intervals: [0, 1, 3, 5, 6, 8, 10],
        name: "Locrian"
    )

    // MARK: - Pentatonic Scales

    /// Major pentatonic scale: W-W-WH-W-WH
    public static let majorPentatonic = ScalePattern(
        intervals: [0, 2, 4, 7, 9],
        name: "Major Pentatonic"
    )

    /// Minor pentatonic scale: WH-W-W-WH-W
    public static let minorPentatonic = ScalePattern(
        intervals: [0, 3, 5, 7, 10],
        name: "Minor Pentatonic"
    )

    // MARK: - Blues and Jazz Scales

    /// Blues scale: WH-W-H-H-WH-W
    public static let blues = ScalePattern(
        intervals: [0, 3, 5, 6, 7, 10],
        name: "Blues"
    )

    /// Whole tone scale: W-W-W-W-W-W
    public static let wholeTone = ScalePattern(
        intervals: [0, 2, 4, 6, 8, 10],
        name: "Whole Tone"
    )

    /// Diminished (half-whole) scale: H-W-H-W-H-W-H-W
    public static let diminished = ScalePattern(
        intervals: [0, 1, 3, 4, 6, 7, 9, 10],
        name: "Diminished"
    )

    /// Chromatic scale: all twelve pitches
    public static let chromatic = ScalePattern(
        intervals: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
        name: "Chromatic"
    )

    // MARK: - Common Scale Patterns Collection

    /// All common scale patterns
    public static let allPatterns: [ScalePattern] = [
        .major,
        .naturalMinor,
        .harmonicMinor,
        .melodicMinor,
        .dorian,
        .phrygian,
        .lydian,
        .mixolydian,
        .locrian,
        .majorPentatonic,
        .minorPentatonic,
        .blues,
        .wholeTone,
        .diminished,
        .chromatic
    ]
}

extension ScalePattern: Equatable {
    public static func == (lhs: ScalePattern, rhs: ScalePattern) -> Bool {
        lhs.intervals == rhs.intervals
    }
}

extension ScalePattern: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(intervals)
    }
}

extension ScalePattern: CustomStringConvertible {
    public var description: String {
        name
    }
}
