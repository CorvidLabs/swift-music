/// Represents a musical interval
///
/// An interval is the distance between two pitches, defined by
/// its numeric distance and quality.
public struct Interval: Sendable {
    /// The numeric distance (1 = unison, 2 = second, etc.)
    public let number: Int

    /// The quality of the interval
    public let quality: IntervalQuality

    /// The number of semitones in the interval
    public let semitones: Int

    /// Creates an interval with a number, quality, and semitone count
    /// - Parameters:
    ///   - number: The interval number (1-based)
    ///   - quality: The interval quality
    ///   - semitones: The number of semitones
    public init(number: Int, quality: IntervalQuality, semitones: Int) {
        self.number = number
        self.quality = quality
        self.semitones = semitones
    }

    /// Returns the inversion of this interval
    ///
    /// For example, a major third (M3) inverts to a minor sixth (m6)
    public var inverted: Interval {
        let invertedNumber = 9 - number
        let invertedSemitones = 12 - semitones

        let invertedQuality: IntervalQuality
        switch quality {
        case .major:
            invertedQuality = .minor
        case .minor:
            invertedQuality = .major
        case .augmented:
            invertedQuality = .diminished
        case .diminished:
            invertedQuality = .augmented
        case .perfect:
            invertedQuality = .perfect
        case .doublyAugmented:
            invertedQuality = .doublyDiminished
        case .doublyDiminished:
            invertedQuality = .doublyAugmented
        }

        return Interval(number: invertedNumber, quality: invertedQuality, semitones: invertedSemitones)
    }

    /// Display name of the interval
    public var displayName: String {
        "\(quality.symbol)\(number)"
    }

    // MARK: - Common Intervals

    /// Perfect unison (0 semitones)
    public static let perfectUnison = Interval(number: 1, quality: .perfect, semitones: 0)

    /// Minor second (1 semitone)
    public static let minorSecond = Interval(number: 2, quality: .minor, semitones: 1)

    /// Major second (2 semitones)
    public static let majorSecond = Interval(number: 2, quality: .major, semitones: 2)

    /// Minor third (3 semitones)
    public static let minorThird = Interval(number: 3, quality: .minor, semitones: 3)

    /// Major third (4 semitones)
    public static let majorThird = Interval(number: 3, quality: .major, semitones: 4)

    /// Perfect fourth (5 semitones)
    public static let perfectFourth = Interval(number: 4, quality: .perfect, semitones: 5)

    /// Augmented fourth / Diminished fifth (6 semitones)
    public static let augmentedFourth = Interval(number: 4, quality: .augmented, semitones: 6)
    public static let diminishedFifth = Interval(number: 5, quality: .diminished, semitones: 6)
    public static let tritone = augmentedFourth

    /// Perfect fifth (7 semitones)
    public static let perfectFifth = Interval(number: 5, quality: .perfect, semitones: 7)

    /// Minor sixth (8 semitones)
    public static let minorSixth = Interval(number: 6, quality: .minor, semitones: 8)

    /// Major sixth (9 semitones)
    public static let majorSixth = Interval(number: 6, quality: .major, semitones: 9)

    /// Minor seventh (10 semitones)
    public static let minorSeventh = Interval(number: 7, quality: .minor, semitones: 10)

    /// Major seventh (11 semitones)
    public static let majorSeventh = Interval(number: 7, quality: .major, semitones: 11)

    /// Perfect octave (12 semitones)
    public static let perfectOctave = Interval(number: 8, quality: .perfect, semitones: 12)

    /// Minor ninth (13 semitones)
    public static let minorNinth = Interval(number: 9, quality: .minor, semitones: 13)

    /// Major ninth (14 semitones)
    public static let majorNinth = Interval(number: 9, quality: .major, semitones: 14)

    /// Augmented ninth (15 semitones)
    public static let augmentedNinth = Interval(number: 9, quality: .augmented, semitones: 15)

    /// Perfect eleventh (17 semitones)
    public static let perfectEleventh = Interval(number: 11, quality: .perfect, semitones: 17)

    /// Augmented eleventh (18 semitones)
    public static let augmentedEleventh = Interval(number: 11, quality: .augmented, semitones: 18)

    /// Perfect thirteenth (21 semitones)
    public static let majorThirteenth = Interval(number: 13, quality: .major, semitones: 21)
}

extension Interval: Equatable {
    public static func == (lhs: Interval, rhs: Interval) -> Bool {
        lhs.semitones == rhs.semitones && lhs.number == rhs.number && lhs.quality == rhs.quality
    }
}

extension Interval: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(number)
        hasher.combine(quality)
        hasher.combine(semitones)
    }
}

extension Interval: CustomStringConvertible {
    public var description: String {
        displayName
    }
}
