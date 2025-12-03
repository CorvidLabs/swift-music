/**
 Represents chord extensions and alterations

 Extensions add color tones beyond the basic chord quality.
 */
public struct ChordExtension: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    // MARK: - Extensions

    /// Add major 9th
    public static let add9 = ChordExtension(rawValue: 1 << 0)

    /// Add major 11th
    public static let add11 = ChordExtension(rawValue: 1 << 1)

    /// Add major 13th
    public static let add13 = ChordExtension(rawValue: 1 << 2)

    // MARK: - Alterations

    /// Flat 9th (minor 9th)
    public static let flat9 = ChordExtension(rawValue: 1 << 3)

    /// Sharp 9th (augmented 9th)
    public static let sharp9 = ChordExtension(rawValue: 1 << 4)

    /// Sharp 11th (augmented 11th)
    public static let sharp11 = ChordExtension(rawValue: 1 << 5)

    /// Flat 13th (minor 13th)
    public static let flat13 = ChordExtension(rawValue: 1 << 6)

    /// Returns the semitone intervals for these extensions
    public var intervals: [Int] {
        var result: [Int] = []

        if contains(.add9) {
            result.append(14) // major 9th
        }
        if contains(.flat9) {
            result.append(13) // minor 9th
        }
        if contains(.sharp9) {
            result.append(15) // augmented 9th
        }
        if contains(.add11) {
            result.append(17) // perfect 11th
        }
        if contains(.sharp11) {
            result.append(18) // augmented 11th
        }
        if contains(.add13) {
            result.append(21) // major 13th
        }
        if contains(.flat13) {
            result.append(20) // minor 13th
        }

        return result.sorted()
    }

    /// Returns a symbol representation of the extensions
    public var symbol: String {
        var parts: [String] = []

        if contains(.add9) {
            parts.append("add9")
        }
        if contains(.flat9) {
            parts.append("♭9")
        }
        if contains(.sharp9) {
            parts.append("♯9")
        }
        if contains(.add11) {
            parts.append("add11")
        }
        if contains(.sharp11) {
            parts.append("♯11")
        }
        if contains(.add13) {
            parts.append("add13")
        }
        if contains(.flat13) {
            parts.append("♭13")
        }

        return parts.joined(separator: " ")
    }
}

extension ChordExtension: Hashable {}

extension ChordExtension: CustomStringConvertible {
    public var description: String {
        symbol.isEmpty ? "no extensions" : symbol
    }
}
