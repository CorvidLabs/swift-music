/**
 Represents MIDI velocity (0-127)

 Velocity controls the volume/intensity of a MIDI note.
 */
public struct MIDIVelocity: Sendable {
    /// The velocity value (0-127)
    public let value: UInt8

    /**
     Creates a MIDI velocity

     - Parameter value: The velocity value (0-127)
     - Throws: MusicError.invalidMIDI if the value is out of range
     */
    public init(_ value: UInt8) throws {
        guard value <= 127 else {
            throw MusicError.invalidMIDI("MIDI velocity must be 0-127, got \(value)")
        }
        self.value = value
    }

    /**
     Creates a MIDI velocity from an integer (clamped to 0-127)

     - Parameter value: The velocity value
     */
    public init(clamped value: Int) {
        self.value = UInt8(max(0, min(127, value)))
    }

    /**
     Creates a MIDI velocity, returning nil if out of range

     - Parameter value: The velocity value
     */
    public init?(unchecked value: UInt8) {
        guard value <= 127 else {
            return nil
        }
        self.value = value
    }

    /// The velocity as a normalized value (0.0-1.0)
    public var normalized: Double {
        Double(value) / 127.0
    }

    // MARK: - Common Dynamics

    /// Pianissimo (pp) - very soft (~20)
    public static let pp = try! MIDIVelocity(20)

    /// Piano (p) - soft (~40)
    public static let p = try! MIDIVelocity(40)

    /// Mezzo-piano (mp) - moderately soft (~60)
    public static let mp = try! MIDIVelocity(60)

    /// Mezzo-forte (mf) - moderately loud (~80)
    public static let mf = try! MIDIVelocity(80)

    /// Forte (f) - loud (~100)
    public static let f = try! MIDIVelocity(100)

    /// Fortissimo (ff) - very loud (~120)
    public static let ff = try! MIDIVelocity(120)

    /// Default/medium velocity
    public static let `default` = try! MIDIVelocity(64)

    /// Silent (note off)
    public static let silent = try! MIDIVelocity(0)
}

extension MIDIVelocity: Equatable {
    public static func == (lhs: MIDIVelocity, rhs: MIDIVelocity) -> Bool {
        lhs.value == rhs.value
    }
}

extension MIDIVelocity: Comparable {
    public static func < (lhs: MIDIVelocity, rhs: MIDIVelocity) -> Bool {
        lhs.value < rhs.value
    }
}

extension MIDIVelocity: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension MIDIVelocity: CustomStringConvertible {
    public var description: String {
        "Velocity(\(value))"
    }
}
