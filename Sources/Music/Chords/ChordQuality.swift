/**
 Represents the quality of a chord

 Chord quality defines the intervals that make up a chord's basic structure.
 */
public enum ChordQuality: Sendable {
    /// Major triad: root, major 3rd, perfect 5th
    case major

    /// Minor triad: root, minor 3rd, perfect 5th
    case minor

    /// Diminished triad: root, minor 3rd, diminished 5th
    case diminished

    /// Augmented triad: root, major 3rd, augmented 5th
    case augmented

    /// Dominant seventh: major triad + minor 7th
    case dominant7

    /// Major seventh: major triad + major 7th
    case major7

    /// Minor seventh: minor triad + minor 7th
    case minor7

    /// Minor major seventh: minor triad + major 7th
    case minorMajor7

    /// Diminished seventh: diminished triad + diminished 7th
    case diminished7

    /// Half-diminished seventh: diminished triad + minor 7th
    case halfDiminished7

    /// Augmented seventh: augmented triad + minor 7th
    case augmented7

    /// Major sixth: major triad + major 6th
    case major6

    /// Minor sixth: minor triad + major 6th
    case minor6

    /// Suspended second: root, major 2nd, perfect 5th
    case sus2

    /// Suspended fourth: root, perfect 4th, perfect 5th
    case sus4

    /// The intervals (in semitones) that define this chord quality
    public var intervals: [Int] {
        switch self {
        case .major:
            return [0, 4, 7]
        case .minor:
            return [0, 3, 7]
        case .diminished:
            return [0, 3, 6]
        case .augmented:
            return [0, 4, 8]
        case .dominant7:
            return [0, 4, 7, 10]
        case .major7:
            return [0, 4, 7, 11]
        case .minor7:
            return [0, 3, 7, 10]
        case .minorMajor7:
            return [0, 3, 7, 11]
        case .diminished7:
            return [0, 3, 6, 9]
        case .halfDiminished7:
            return [0, 3, 6, 10]
        case .augmented7:
            return [0, 4, 8, 10]
        case .major6:
            return [0, 4, 7, 9]
        case .minor6:
            return [0, 3, 7, 9]
        case .sus2:
            return [0, 2, 7]
        case .sus4:
            return [0, 5, 7]
        }
    }

    /// The chord symbol for this quality
    public var symbol: String {
        switch self {
        case .major:
            return ""
        case .minor:
            return "m"
        case .diminished:
            return "dim"
        case .augmented:
            return "aug"
        case .dominant7:
            return "7"
        case .major7:
            return "maj7"
        case .minor7:
            return "m7"
        case .minorMajor7:
            return "m(maj7)"
        case .diminished7:
            return "dim7"
        case .halfDiminished7:
            return "m7♭5"
        case .augmented7:
            return "aug7"
        case .major6:
            return "6"
        case .minor6:
            return "m6"
        case .sus2:
            return "sus2"
        case .sus4:
            return "sus4"
        }
    }

    /// Display name of the quality
    public var displayName: String {
        switch self {
        case .major:
            return "Major"
        case .minor:
            return "Minor"
        case .diminished:
            return "Diminished"
        case .augmented:
            return "Augmented"
        case .dominant7:
            return "Dominant 7th"
        case .major7:
            return "Major 7th"
        case .minor7:
            return "Minor 7th"
        case .minorMajor7:
            return "Minor Major 7th"
        case .diminished7:
            return "Diminished 7th"
        case .halfDiminished7:
            return "Half-Diminished 7th"
        case .augmented7:
            return "Augmented 7th"
        case .major6:
            return "Major 6th"
        case .minor6:
            return "Minor 6th"
        case .sus2:
            return "Suspended 2nd"
        case .sus4:
            return "Suspended 4th"
        }
    }
}

extension ChordQuality: Equatable {}
extension ChordQuality: Hashable {}

extension ChordQuality: CustomStringConvertible {
    public var description: String {
        displayName
    }
}
