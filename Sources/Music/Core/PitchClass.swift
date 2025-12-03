/**
 Represents one of the twelve pitch classes in Western music theory

 Pitch classes are the fundamental building blocks of music, representing
 the twelve chromatic notes independent of octave.
 */
public enum PitchClass: Int, CaseIterable, Sendable {
    case c = 0
    case cSharp = 1
    case d = 2
    case dSharp = 3
    case e = 4
    case f = 5
    case fSharp = 6
    case g = 7
    case gSharp = 8
    case a = 9
    case aSharp = 10
    case b = 11

    /**
     Transposes this pitch class by a given number of semitones

     - Parameter semitones: The number of semitones to transpose (can be negative)
     - Returns: The transposed pitch class
     */
    public func transposed(by semitones: Int) -> PitchClass {
        let newValue = (rawValue + semitones).modulo(12)
        return PitchClass(rawValue: newValue)!
    }

    /**
     Calculates the distance in semitones from this pitch class to another

     - Parameter other: The target pitch class
     - Returns: The number of semitones (0-11) ascending from this pitch class to the target
     */
    public func distance(to other: PitchClass) -> Int {
        (other.rawValue - rawValue).modulo(12)
    }

    /// The enharmonic equivalent using flats instead of sharps
    public var enharmonicFlat: PitchClass? {
        switch self {
        case .cSharp: return .d
        case .dSharp: return .e
        case .fSharp: return .g
        case .gSharp: return .a
        case .aSharp: return .b
        default: return nil
        }
    }

    /// Returns the display name for the pitch class
    public var displayName: String {
        switch self {
        case .c: return "C"
        case .cSharp: return "C♯"
        case .d: return "D"
        case .dSharp: return "D♯"
        case .e: return "E"
        case .f: return "F"
        case .fSharp: return "F♯"
        case .g: return "G"
        case .gSharp: return "G♯"
        case .a: return "A"
        case .aSharp: return "A♯"
        case .b: return "B"
        }
    }
}

extension PitchClass: CustomStringConvertible {
    public var description: String {
        displayName
    }
}

// MARK: - Integer Helpers

extension Int {
    /// Modulo operation that always returns a positive result
    fileprivate func modulo(_ divisor: Int) -> Int {
        let remainder = self % divisor
        return remainder >= 0 ? remainder : remainder + divisor
    }
}
