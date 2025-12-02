/// Represents a chord progression in a specific key
///
/// A chord progression is a sequence of chords, typically described
/// using Roman numeral analysis.
public struct ChordProgression: Sendable {
    /// The scale (key) of the progression
    public let scale: Scale

    /// The Roman numerals defining the progression
    public let numerals: [RomanNumeral]

    /// Creates a chord progression
    /// - Parameters:
    ///   - scale: The scale (key) of the progression
    ///   - numerals: The Roman numerals defining the progression
    public init(scale: Scale, numerals: [RomanNumeral]) {
        self.scale = scale
        self.numerals = numerals
    }

    /// The actual chords in this progression
    public var chords: [Chord] {
        numerals.map { $0.chord(in: scale) }
    }

    /// Transposes this progression to a new key
    /// - Parameter newRoot: The root of the new key
    /// - Returns: The transposed progression
    public func transposed(to newRoot: PitchClass) -> ChordProgression {
        let newScale = Scale(root: newRoot, pattern: scale.pattern)
        return ChordProgression(scale: newScale, numerals: numerals)
    }

    /// Display name of the progression
    public var displayName: String {
        let numeralString = numerals.map { $0.display }.joined(separator: " - ")
        return "\(scale.displayName): \(numeralString)"
    }

    // MARK: - Common Progressions (Major)

    /// I - IV - V (the most fundamental progression)
    public static func major_I_IV_V(root: PitchClass) -> ChordProgression {
        ChordProgression(
            scale: Scale(root: root, pattern: .major),
            numerals: [.majorI, .majorIV, .majorV]
        )
    }

    /// I - V - vi - IV (pop progression, "Axis of Awesome")
    public static func pop_I_V_vi_IV(root: PitchClass) -> ChordProgression {
        ChordProgression(
            scale: Scale(root: root, pattern: .major),
            numerals: [.majorI, .majorV, .minorVI, .majorIV]
        )
    }

    /// I - vi - IV - V (50s progression, "Heart and Soul")
    public static func fifties_I_vi_IV_V(root: PitchClass) -> ChordProgression {
        ChordProgression(
            scale: Scale(root: root, pattern: .major),
            numerals: [.majorI, .minorVI, .majorIV, .majorV]
        )
    }

    /// I - IV - I - V (12-bar blues foundation)
    public static func blues12Bar(root: PitchClass) -> ChordProgression {
        let dominant7_I = RomanNumeral(degree: 1, quality: .dominant7)
        let dominant7_IV = RomanNumeral(degree: 4, quality: .dominant7)
        let dominant7_V = RomanNumeral(degree: 5, quality: .dominant7)

        return ChordProgression(
            scale: Scale(root: root, pattern: .major),
            numerals: [
                // Bars 1-4
                dominant7_I, dominant7_I, dominant7_I, dominant7_I,
                // Bars 5-6
                dominant7_IV, dominant7_IV,
                // Bars 7-8
                dominant7_I, dominant7_I,
                // Bars 9-10
                dominant7_V, dominant7_IV,
                // Bars 11-12
                dominant7_I, dominant7_V
            ]
        )
    }

    /// ii - V - I (jazz progression)
    public static func jazz_ii_V_I(root: PitchClass) -> ChordProgression {
        let minor7_ii = RomanNumeral(degree: 2, quality: .minor7)
        let dominant7_V = RomanNumeral(degree: 5, quality: .dominant7)
        let major7_I = RomanNumeral(degree: 1, quality: .major7)

        return ChordProgression(
            scale: Scale(root: root, pattern: .major),
            numerals: [minor7_ii, dominant7_V, major7_I]
        )
    }

    /// iii - vi - ii - V (circle progression)
    public static func circle_iii_vi_ii_V(root: PitchClass) -> ChordProgression {
        let minor7_iii = RomanNumeral(degree: 3, quality: .minor7)
        let minor7_vi = RomanNumeral(degree: 6, quality: .minor7)
        let minor7_ii = RomanNumeral(degree: 2, quality: .minor7)
        let dominant7_V = RomanNumeral(degree: 5, quality: .dominant7)

        return ChordProgression(
            scale: Scale(root: root, pattern: .major),
            numerals: [minor7_iii, minor7_vi, minor7_ii, dominant7_V]
        )
    }

    // MARK: - Common Progressions (Minor)

    /// i - iv - v (minor progression)
    public static func minor_i_iv_v(root: PitchClass) -> ChordProgression {
        ChordProgression(
            scale: Scale(root: root, pattern: .naturalMinor),
            numerals: [.minorI, .minorIV, .minorV]
        )
    }

    /// i - VI - III - VII (Andalusian cadence)
    public static func andalusian_i_VI_III_VII(root: PitchClass) -> ChordProgression {
        ChordProgression(
            scale: Scale(root: root, pattern: .naturalMinor),
            numerals: [.minorI, .majorVI, .majorIII, .majorVII]
        )
    }

    /// i - iv - VII - III (minor progression)
    public static func minor_i_iv_VII_III(root: PitchClass) -> ChordProgression {
        ChordProgression(
            scale: Scale(root: root, pattern: .naturalMinor),
            numerals: [.minorI, .minorIV, .majorVII, .majorIII]
        )
    }

    // MARK: - Preset Collections

    /// Common pop progressions
    public static func popProgressions(root: PitchClass) -> [ChordProgression] {
        [
            .pop_I_V_vi_IV(root: root),
            .fifties_I_vi_IV_V(root: root),
            .major_I_IV_V(root: root)
        ]
    }

    /// Common jazz progressions
    public static func jazzProgressions(root: PitchClass) -> [ChordProgression] {
        [
            .jazz_ii_V_I(root: root),
            .circle_iii_vi_ii_V(root: root)
        ]
    }

    /// Common blues progressions
    public static func bluesProgressions(root: PitchClass) -> [ChordProgression] {
        [
            .blues12Bar(root: root)
        ]
    }
}

extension ChordProgression: Equatable {
    public static func == (lhs: ChordProgression, rhs: ChordProgression) -> Bool {
        lhs.scale == rhs.scale && lhs.numerals == rhs.numerals
    }
}

extension ChordProgression: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(scale)
        hasher.combine(numerals)
    }
}

extension ChordProgression: CustomStringConvertible {
    public var description: String {
        displayName
    }
}
