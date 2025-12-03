/**
 Represents the quality of a musical interval

 Interval quality describes the character of an interval
 beyond its numeric distance (e.g., major 3rd vs minor 3rd).
 */
public enum IntervalQuality: Sendable {
    /// Perfect intervals (unison, 4th, 5th, octave)
    case perfect

    /// Major intervals (2nd, 3rd, 6th, 7th)
    case major

    /// Minor intervals (2nd, 3rd, 6th, 7th)
    case minor

    /// Augmented interval (one semitone larger than major/perfect)
    case augmented

    /// Diminished interval (one semitone smaller than minor/perfect)
    case diminished

    /// Doubly augmented interval (two semitones larger than major/perfect)
    case doublyAugmented

    /// Doubly diminished interval (two semitones smaller than minor/perfect)
    case doublyDiminished

    /// Display symbol for the quality
    public var symbol: String {
        switch self {
        case .perfect: return "P"
        case .major: return "M"
        case .minor: return "m"
        case .augmented: return "A"
        case .diminished: return "d"
        case .doublyAugmented: return "AA"
        case .doublyDiminished: return "dd"
        }
    }

    /// Full name of the quality
    public var displayName: String {
        switch self {
        case .perfect: return "Perfect"
        case .major: return "Major"
        case .minor: return "Minor"
        case .augmented: return "Augmented"
        case .diminished: return "Diminished"
        case .doublyAugmented: return "Doubly Augmented"
        case .doublyDiminished: return "Doubly Diminished"
        }
    }
}

extension IntervalQuality: CustomStringConvertible {
    public var description: String {
        displayName
    }
}

extension IntervalQuality: Equatable {}
extension IntervalQuality: Hashable {}
