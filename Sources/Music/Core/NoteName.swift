/**
 Represents a note name with its specific accidental

 While `PitchClass` represents the twelve chromatic pitches,
 `NoteName` includes enharmonic spellings (e.g., C♯ vs D♭).
 */
public enum NoteName: Sendable {
    case c
    case cSharp
    case dFlat
    case d
    case dSharp
    case eFlat
    case e
    case eSharp
    case fFlat
    case f
    case fSharp
    case gFlat
    case g
    case gSharp
    case aFlat
    case a
    case aSharp
    case bFlat
    case b
    case bSharp
    case cFlat

    /// The pitch class this note name represents
    public var pitchClass: PitchClass {
        switch self {
        case .c, .bSharp:
            return .c
        case .cSharp, .dFlat:
            return .cSharp
        case .d:
            return .d
        case .dSharp, .eFlat:
            return .dSharp
        case .e, .fFlat:
            return .e
        case .f, .eSharp:
            return .f
        case .fSharp, .gFlat:
            return .fSharp
        case .g:
            return .g
        case .gSharp, .aFlat:
            return .gSharp
        case .a:
            return .a
        case .aSharp, .bFlat:
            return .aSharp
        case .b, .cFlat:
            return .b
        }
    }

    /// The display name with proper accidental symbols
    public var display: String {
        switch self {
        case .c: return "C"
        case .cSharp: return "C♯"
        case .dFlat: return "D♭"
        case .d: return "D"
        case .dSharp: return "D♯"
        case .eFlat: return "E♭"
        case .e: return "E"
        case .eSharp: return "E♯"
        case .fFlat: return "F♭"
        case .f: return "F"
        case .fSharp: return "F♯"
        case .gFlat: return "G♭"
        case .g: return "G"
        case .gSharp: return "G♯"
        case .aFlat: return "A♭"
        case .a: return "A"
        case .aSharp: return "A♯"
        case .bFlat: return "B♭"
        case .b: return "B"
        case .bSharp: return "B♯"
        case .cFlat: return "C♭"
        }
    }

    /// Returns the preferred sharp name for a pitch class
    public static func preferredSharp(for pitchClass: PitchClass) -> NoteName {
        switch pitchClass {
        case .c: return .c
        case .cSharp: return .cSharp
        case .d: return .d
        case .dSharp: return .dSharp
        case .e: return .e
        case .f: return .f
        case .fSharp: return .fSharp
        case .g: return .g
        case .gSharp: return .gSharp
        case .a: return .a
        case .aSharp: return .aSharp
        case .b: return .b
        }
    }

    /// Returns the preferred flat name for a pitch class
    public static func preferredFlat(for pitchClass: PitchClass) -> NoteName {
        switch pitchClass {
        case .c: return .c
        case .cSharp: return .dFlat
        case .d: return .d
        case .dSharp: return .eFlat
        case .e: return .e
        case .f: return .f
        case .fSharp: return .gFlat
        case .g: return .g
        case .gSharp: return .aFlat
        case .a: return .a
        case .aSharp: return .bFlat
        case .b: return .b
        }
    }
}

extension NoteName: CustomStringConvertible {
    public var description: String {
        display
    }
}

extension NoteName: Equatable {
    public static func == (lhs: NoteName, rhs: NoteName) -> Bool {
        lhs.pitchClass == rhs.pitchClass
    }
}
