/// Represents a MIDI channel (0-15, displayed as 1-16)
///
/// MIDI supports 16 independent channels for different instruments or parts.
public struct MIDIChannel: Sendable {
    /// The channel number (0-15)
    public let value: UInt8

    /// Creates a MIDI channel
    /// - Parameter value: The channel number (0-15)
    /// - Throws: MusicError.invalidMIDI if the value is out of range
    public init(_ value: UInt8) throws {
        guard value < 16 else {
            throw MusicError.invalidMIDI("MIDI channel must be 0-15, got \(value)")
        }
        self.value = value
    }

    /// Creates a MIDI channel from a display number (1-16)
    /// - Parameter displayNumber: The display number (1-16)
    /// - Throws: MusicError.invalidMIDI if the value is out of range
    public init(displayNumber: Int) throws {
        guard (1...16).contains(displayNumber) else {
            throw MusicError.invalidMIDI("MIDI channel display number must be 1-16, got \(displayNumber)")
        }
        self.value = UInt8(displayNumber - 1)
    }

    /// Creates a MIDI channel, returning nil if out of range
    /// - Parameter value: The channel number (0-15)
    public init?(unchecked value: UInt8) {
        guard value < 16 else {
            return nil
        }
        self.value = value
    }

    /// The display number (1-16)
    public var displayNumber: Int {
        Int(value) + 1
    }

    // MARK: - Common Channels

    /// Channel 1 (0)
    public static let channel1 = try! MIDIChannel(0)

    /// Channel 10 (9) - typically used for drums
    public static let drums = try! MIDIChannel(9)

    /// All 16 MIDI channels
    public static let allChannels: [MIDIChannel] = (0..<16).compactMap { try? MIDIChannel($0) }
}

extension MIDIChannel: Equatable {
    public static func == (lhs: MIDIChannel, rhs: MIDIChannel) -> Bool {
        lhs.value == rhs.value
    }
}

extension MIDIChannel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension MIDIChannel: Comparable {
    public static func < (lhs: MIDIChannel, rhs: MIDIChannel) -> Bool {
        lhs.value < rhs.value
    }
}

extension MIDIChannel: CustomStringConvertible {
    public var description: String {
        "Channel \(displayNumber)"
    }
}
