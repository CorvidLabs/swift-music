/// Represents a musical tempo
///
/// Tempo defines the speed of music in beats per minute (BPM).
public struct Tempo: Sendable {
    /// Beats per minute
    public let bpm: Double

    /// Creates a tempo with a specific BPM
    /// - Parameter bpm: Beats per minute
    public init(bpm: Double) {
        self.bpm = bpm
    }

    /// The duration of a single beat in seconds
    public var beatDuration: Double {
        60.0 / bpm
    }

    /// Calculates the duration of a note in seconds
    /// - Parameter duration: The note duration
    /// - Returns: The duration in seconds
    public func duration(of duration: NoteDuration) -> Double {
        beatDuration * duration.relativeDuration * 4.0 // assuming quarter note = 1 beat
    }

    /// Calculates the duration of a custom relative duration in seconds
    /// - Parameter relativeDuration: The relative duration (e.g., 1.5 for dotted quarter)
    /// - Returns: The duration in seconds
    public func duration(relativeDuration: Double) -> Double {
        beatDuration * relativeDuration * 4.0
    }

    // MARK: - Common Tempos

    /// Largo (40-60 BPM)
    public static let largo = Tempo(bpm: 50)

    /// Adagio (60-80 BPM)
    public static let adagio = Tempo(bpm: 70)

    /// Andante (80-100 BPM)
    public static let andante = Tempo(bpm: 90)

    /// Moderato (100-120 BPM)
    public static let moderato = Tempo(bpm: 110)

    /// Allegro (120-140 BPM)
    public static let allegro = Tempo(bpm: 130)

    /// Vivace (140-160 BPM)
    public static let vivace = Tempo(bpm: 150)

    /// Presto (160-200 BPM)
    public static let presto = Tempo(bpm: 180)
}

/// Traditional tempo markings
public enum TempoMarking: String, Sendable {
    case grave = "Grave"
    case largo = "Largo"
    case lento = "Lento"
    case adagio = "Adagio"
    case andante = "Andante"
    case moderato = "Moderato"
    case allegretto = "Allegretto"
    case allegro = "Allegro"
    case vivace = "Vivace"
    case presto = "Presto"
    case prestissimo = "Prestissimo"

    /// Typical BPM range for this marking
    public var bpmRange: ClosedRange<Double> {
        switch self {
        case .grave:
            return 25...45
        case .largo:
            return 40...60
        case .lento:
            return 45...60
        case .adagio:
            return 60...80
        case .andante:
            return 80...100
        case .moderato:
            return 100...120
        case .allegretto:
            return 100...128
        case .allegro:
            return 120...140
        case .vivace:
            return 140...160
        case .presto:
            return 160...200
        case .prestissimo:
            return 200...240
        }
    }

    /// A typical tempo for this marking
    public var typicalTempo: Tempo {
        let midpoint = (bpmRange.lowerBound + bpmRange.upperBound) / 2
        return Tempo(bpm: midpoint)
    }
}

extension Tempo: Equatable {
    public static func == (lhs: Tempo, rhs: Tempo) -> Bool {
        lhs.bpm == rhs.bpm
    }
}

extension Tempo: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(bpm)
    }
}

extension Tempo: Comparable {
    public static func < (lhs: Tempo, rhs: Tempo) -> Bool {
        lhs.bpm < rhs.bpm
    }
}

extension Tempo: CustomStringConvertible {
    public var description: String {
        "\(Int(bpm)) BPM"
    }
}

extension TempoMarking: CaseIterable {}
extension TempoMarking: Equatable {}
extension TempoMarking: Hashable {}
