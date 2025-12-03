/**
 Represents a time signature

 A time signature defines the rhythmic meter of music, indicating
 how many beats are in each measure and what note value gets the beat.
 */
public struct TimeSignature: Sendable {
    /// Number of beats per measure
    public let beats: Int

    /// Note value that gets one beat (typically 2, 4, 8, or 16)
    public let noteValue: Int

    /**
     Creates a time signature

     - Parameters:
       - beats: Number of beats per measure
       - noteValue: Note value that gets one beat
     */
    public init(beats: Int, noteValue: Int) {
        self.beats = beats
        self.noteValue = noteValue
    }

    /// Whether this is a compound meter (beats divisible by 3)
    public var isCompound: Bool {
        beats % 3 == 0 && beats > 3
    }

    /// Whether this is a simple meter (beats not divisible by 3)
    public var isSimple: Bool {
        !isCompound
    }

    /// The number of strong beats in this meter
    public var strongBeats: [Int] {
        switch beats {
        case 2, 3:
            return [1]
        case 4:
            return [1, 3]
        case 6:
            return [1, 4]
        case 9:
            return [1, 4, 7]
        case 12:
            return [1, 4, 7, 10]
        default:
            return [1]
        }
    }

    /// Display representation (e.g., "4/4")
    public var display: String {
        "\(beats)/\(noteValue)"
    }

    // MARK: - Common Time Signatures

    /// 4/4 time (common time)
    public static let fourFour = TimeSignature(beats: 4, noteValue: 4)
    public static let commonTime = fourFour

    /// 3/4 time (waltz time)
    public static let threeFour = TimeSignature(beats: 3, noteValue: 4)
    public static let waltzTime = threeFour

    /// 2/4 time (march time)
    public static let twoFour = TimeSignature(beats: 2, noteValue: 4)
    public static let marchTime = twoFour

    /// 6/8 time (compound duple)
    public static let sixEight = TimeSignature(beats: 6, noteValue: 8)

    /// 9/8 time (compound triple)
    public static let nineEight = TimeSignature(beats: 9, noteValue: 8)

    /// 12/8 time (compound quadruple)
    public static let twelveEight = TimeSignature(beats: 12, noteValue: 8)

    /// 5/4 time
    public static let fiveFour = TimeSignature(beats: 5, noteValue: 4)

    /// 7/4 time
    public static let sevenFour = TimeSignature(beats: 7, noteValue: 4)

    /// 7/8 time
    public static let sevenEight = TimeSignature(beats: 7, noteValue: 8)

    /// 2/2 time (cut time)
    public static let twoTwo = TimeSignature(beats: 2, noteValue: 2)
    public static let cutTime = twoTwo

    /// 3/8 time
    public static let threeEight = TimeSignature(beats: 3, noteValue: 8)

    // MARK: - Common Time Signatures Collection

    /// All common time signatures
    public static let commonTimeSignatures: [TimeSignature] = [
        .fourFour,
        .threeFour,
        .twoFour,
        .sixEight,
        .nineEight,
        .twelveEight,
        .fiveFour,
        .sevenFour,
        .sevenEight,
        .twoTwo,
        .threeEight
    ]
}

extension TimeSignature: Equatable {
    public static func == (lhs: TimeSignature, rhs: TimeSignature) -> Bool {
        lhs.beats == rhs.beats && lhs.noteValue == rhs.noteValue
    }
}

extension TimeSignature: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(beats)
        hasher.combine(noteValue)
    }
}

extension TimeSignature: CustomStringConvertible {
    public var description: String {
        display
    }
}
