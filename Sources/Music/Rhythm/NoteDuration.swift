/// Represents the duration of a musical note
///
/// Note durations are expressed as fractions of a whole note.
public enum NoteDuration: Sendable {
    /// Whole note (4 beats in 4/4 time)
    case whole

    /// Half note (2 beats in 4/4 time)
    case half

    /// Quarter note (1 beat in 4/4 time)
    case quarter

    /// Eighth note (1/2 beat in 4/4 time)
    case eighth

    /// Sixteenth note (1/4 beat in 4/4 time)
    case sixteenth

    /// Thirty-second note
    case thirtySecond

    /// Sixty-fourth note
    case sixtyFourth

    /// The relative duration as a fraction of a whole note
    public var relativeDuration: Double {
        switch self {
        case .whole:
            return 1.0
        case .half:
            return 1.0 / 2.0
        case .quarter:
            return 1.0 / 4.0
        case .eighth:
            return 1.0 / 8.0
        case .sixteenth:
            return 1.0 / 16.0
        case .thirtySecond:
            return 1.0 / 32.0
        case .sixtyFourth:
            return 1.0 / 64.0
        }
    }

    /// Returns a dotted version of this duration (1.5x the original)
    public var dotted: Double {
        relativeDuration * 1.5
    }

    /// Returns a double-dotted version of this duration (1.75x the original)
    public var doubleDotted: Double {
        relativeDuration * 1.75
    }

    /// Returns a triplet version of this duration (2/3 of the original)
    public var triplet: Double {
        relativeDuration * (2.0 / 3.0)
    }

    /// The name of the note duration
    public var displayName: String {
        switch self {
        case .whole:
            return "Whole"
        case .half:
            return "Half"
        case .quarter:
            return "Quarter"
        case .eighth:
            return "Eighth"
        case .sixteenth:
            return "Sixteenth"
        case .thirtySecond:
            return "Thirty-second"
        case .sixtyFourth:
            return "Sixty-fourth"
        }
    }

    /// Musical notation symbol
    public var symbol: String {
        switch self {
        case .whole:
            return "𝅝"
        case .half:
            return "𝅗𝅥"
        case .quarter:
            return "♩"
        case .eighth:
            return "♪"
        case .sixteenth:
            return "𝅘𝅥𝅯"
        case .thirtySecond:
            return "𝅘𝅥𝅰"
        case .sixtyFourth:
            return "𝅘𝅥𝅱"
        }
    }
}

extension NoteDuration: CaseIterable {}
extension NoteDuration: Equatable {}
extension NoteDuration: Hashable {}

extension NoteDuration: CustomStringConvertible {
    public var description: String {
        displayName
    }
}
