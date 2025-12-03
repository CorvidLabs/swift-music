/**
 Represents a Roman numeral chord notation

 Roman numeral analysis is used to describe chords in relation
 to a key, independent of the specific root note.
 */
public struct RomanNumeral: Sendable {
    /// The scale degree (1-7)
    public let degree: Int

    /// The quality of the chord
    public let quality: ChordQuality

    /**
     Creates a Roman numeral

     - Parameters:
       - degree: The scale degree (1-7)
       - quality: The chord quality
     */
    public init(degree: Int, quality: ChordQuality) {
        self.degree = degree
        self.quality = quality
    }

    /// The Roman numeral display string
    public var display: String {
        let numeral: String
        switch degree {
        case 1: numeral = "I"
        case 2: numeral = "II"
        case 3: numeral = "III"
        case 4: numeral = "IV"
        case 5: numeral = "V"
        case 6: numeral = "VI"
        case 7: numeral = "VII"
        default: numeral = "\(degree)"
        }

        // Minor chords use lowercase
        let adjustedNumeral: String
        switch quality {
        case .minor, .minor7, .minor6, .minorMajor7:
            adjustedNumeral = numeral.lowercased()
        case .diminished, .diminished7, .halfDiminished7:
            adjustedNumeral = numeral.lowercased()
        default:
            adjustedNumeral = numeral
        }

        // Add quality suffix
        let suffix: String
        switch quality {
        case .diminished:
            suffix = "°"
        case .diminished7:
            suffix = "°7"
        case .halfDiminished7:
            suffix = "ø7"
        case .augmented:
            suffix = "+"
        case .dominant7:
            suffix = "7"
        case .major7:
            suffix = "maj7"
        case .minor7:
            suffix = "7"
        case .minorMajor7:
            suffix = "(maj7)"
        case .augmented7:
            suffix = "+7"
        case .major6:
            suffix = "6"
        case .minor6:
            suffix = "6"
        case .sus2:
            suffix = "sus2"
        case .sus4:
            suffix = "sus4"
        default:
            suffix = ""
        }

        return adjustedNumeral + suffix
    }

    /**
     Creates a chord from this Roman numeral in a specific key

     - Parameter scale: The scale defining the key
     - Returns: The chord
     */
    public func chord(in scale: Scale) -> Chord {
        let rootPitchClass = scale.root.transposed(by: scale.pattern.intervals[degree - 1])
        return Chord(root: rootPitchClass, quality: quality)
    }

    // MARK: - Common Roman Numerals (Major Key)

    /// Tonic (I) - major
    public static let majorI = RomanNumeral(degree: 1, quality: .major)

    /// Supertonic (ii) - minor
    public static let minorII = RomanNumeral(degree: 2, quality: .minor)

    /// Mediant (iii) - minor
    public static let minorIII = RomanNumeral(degree: 3, quality: .minor)

    /// Subdominant (IV) - major
    public static let majorIV = RomanNumeral(degree: 4, quality: .major)

    /// Dominant (V) - major
    public static let majorV = RomanNumeral(degree: 5, quality: .major)

    /// Dominant seventh (V7)
    public static let dominantV7 = RomanNumeral(degree: 5, quality: .dominant7)

    /// Submediant (vi) - minor
    public static let minorVI = RomanNumeral(degree: 6, quality: .minor)

    /// Leading tone (vii°) - diminished
    public static let diminishedVII = RomanNumeral(degree: 7, quality: .diminished)

    // MARK: - Common Roman Numerals (Minor Key)

    /// Tonic (i) - minor
    public static let minorI = RomanNumeral(degree: 1, quality: .minor)

    /// Diminished supertonic (ii°) - diminished
    public static let diminishedII = RomanNumeral(degree: 2, quality: .diminished)

    /// Mediant (III) - major
    public static let majorIII = RomanNumeral(degree: 3, quality: .major)

    /// Subdominant (iv) - minor
    public static let minorIV = RomanNumeral(degree: 4, quality: .minor)

    /// Dominant (v) - minor (natural minor)
    public static let minorV = RomanNumeral(degree: 5, quality: .minor)

    /// Submediant (VI) - major
    public static let majorVI = RomanNumeral(degree: 6, quality: .major)

    /// Subtonic (VII) - major
    public static let majorVII = RomanNumeral(degree: 7, quality: .major)
}

extension RomanNumeral: Equatable {
    public static func == (lhs: RomanNumeral, rhs: RomanNumeral) -> Bool {
        lhs.degree == rhs.degree && lhs.quality == rhs.quality
    }
}

extension RomanNumeral: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(degree)
        hasher.combine(quality)
    }
}

extension RomanNumeral: CustomStringConvertible {
    public var description: String {
        display
    }
}
