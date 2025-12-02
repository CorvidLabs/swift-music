import Foundation

/// Represents a MIDI message
///
/// MIDI messages are the fundamental communication protocol for MIDI devices.
public enum MIDIMessage: Sendable {
    /// Note on message
    case noteOn(channel: MIDIChannel, note: MIDINote, velocity: MIDIVelocity)

    /// Note off message
    case noteOff(channel: MIDIChannel, note: MIDINote, velocity: MIDIVelocity)

    /// Control change message
    case controlChange(channel: MIDIChannel, controller: UInt8, value: UInt8)

    /// Program change message
    case programChange(channel: MIDIChannel, program: UInt8)

    /// Pitch bend message (-8192 to 8191)
    case pitchBend(channel: MIDIChannel, value: Int16)

    /// Channel aftertouch (pressure)
    case channelPressure(channel: MIDIChannel, pressure: UInt8)

    /// Polyphonic aftertouch
    case polyPressure(channel: MIDIChannel, note: MIDINote, pressure: UInt8)

    /// System exclusive message
    case sysex(data: [UInt8])

    /// The raw MIDI bytes for this message
    public var bytes: [UInt8] {
        switch self {
        case .noteOn(let channel, let note, let velocity):
            return [0x90 | channel.value, note.value, velocity.value]

        case .noteOff(let channel, let note, let velocity):
            return [0x80 | channel.value, note.value, velocity.value]

        case .controlChange(let channel, let controller, let value):
            return [0xB0 | channel.value, controller, value]

        case .programChange(let channel, let program):
            return [0xC0 | channel.value, program]

        case .pitchBend(let channel, let value):
            let unsigned = UInt16(bitPattern: value &+ 8192)
            let lsb = UInt8(unsigned & 0x7F)
            let msb = UInt8((unsigned >> 7) & 0x7F)
            return [0xE0 | channel.value, lsb, msb]

        case .channelPressure(let channel, let pressure):
            return [0xD0 | channel.value, pressure]

        case .polyPressure(let channel, let note, let pressure):
            return [0xA0 | channel.value, note.value, pressure]

        case .sysex(let data):
            return [0xF0] + data + [0xF7]
        }
    }

    /// Parses a MIDI message from bytes
    /// - Parameter bytes: The MIDI bytes
    /// - Returns: The parsed MIDI message
    /// - Throws: MusicError.parsingError if the bytes are invalid
    public static func parse(_ bytes: [UInt8]) throws -> MIDIMessage {
        guard let firstByte = bytes.first else {
            throw MusicError.parsingError("Empty MIDI message")
        }

        // System exclusive
        if firstByte == 0xF0 {
            guard let endIndex = bytes.lastIndex(of: 0xF7) else {
                throw MusicError.parsingError("Incomplete sysex message")
            }
            let data = Array(bytes[1..<endIndex])
            return .sysex(data: data)
        }

        let status = firstByte & 0xF0
        let channelValue = firstByte & 0x0F
        guard let channel = try? MIDIChannel(channelValue) else {
            throw MusicError.parsingError("Invalid MIDI channel: \(channelValue)")
        }

        switch status {
        case 0x90: // Note On
            guard bytes.count >= 3 else {
                throw MusicError.parsingError("Incomplete note on message")
            }
            guard let note = try? MIDINote(bytes[1]),
                  let velocity = try? MIDIVelocity(bytes[2]) else {
                throw MusicError.parsingError("Invalid note on parameters")
            }
            // Note: velocity 0 is sometimes used as note off
            if velocity.value == 0 {
                return .noteOff(channel: channel, note: note, velocity: velocity)
            }
            return .noteOn(channel: channel, note: note, velocity: velocity)

        case 0x80: // Note Off
            guard bytes.count >= 3 else {
                throw MusicError.parsingError("Incomplete note off message")
            }
            guard let note = try? MIDINote(bytes[1]),
                  let velocity = try? MIDIVelocity(bytes[2]) else {
                throw MusicError.parsingError("Invalid note off parameters")
            }
            return .noteOff(channel: channel, note: note, velocity: velocity)

        case 0xB0: // Control Change
            guard bytes.count >= 3 else {
                throw MusicError.parsingError("Incomplete control change message")
            }
            return .controlChange(channel: channel, controller: bytes[1], value: bytes[2])

        case 0xC0: // Program Change
            guard bytes.count >= 2 else {
                throw MusicError.parsingError("Incomplete program change message")
            }
            return .programChange(channel: channel, program: bytes[1])

        case 0xE0: // Pitch Bend
            guard bytes.count >= 3 else {
                throw MusicError.parsingError("Incomplete pitch bend message")
            }
            let unsigned = UInt16(bytes[1]) | (UInt16(bytes[2]) << 7)
            let value = Int16(bitPattern: unsigned) &- 8192
            return .pitchBend(channel: channel, value: value)

        case 0xD0: // Channel Pressure
            guard bytes.count >= 2 else {
                throw MusicError.parsingError("Incomplete channel pressure message")
            }
            return .channelPressure(channel: channel, pressure: bytes[1])

        case 0xA0: // Polyphonic Pressure
            guard bytes.count >= 3 else {
                throw MusicError.parsingError("Incomplete poly pressure message")
            }
            guard let note = try? MIDINote(bytes[1]) else {
                throw MusicError.parsingError("Invalid poly pressure note")
            }
            return .polyPressure(channel: channel, note: note, pressure: bytes[2])

        default:
            throw MusicError.parsingError("Unknown MIDI message type: \(String(format: "0x%02X", status))")
        }
    }
}

extension MIDIMessage: Equatable {
    public static func == (lhs: MIDIMessage, rhs: MIDIMessage) -> Bool {
        lhs.bytes == rhs.bytes
    }
}

extension MIDIMessage: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(bytes)
    }
}

extension MIDIMessage: CustomStringConvertible {
    public var description: String {
        switch self {
        case .noteOn(let channel, let note, let velocity):
            return "Note On: \(note) on \(channel) with \(velocity)"
        case .noteOff(let channel, let note, let velocity):
            return "Note Off: \(note) on \(channel) with \(velocity)"
        case .controlChange(let channel, let controller, let value):
            return "CC: Controller \(controller) = \(value) on \(channel)"
        case .programChange(let channel, let program):
            return "Program Change: \(program) on \(channel)"
        case .pitchBend(let channel, let value):
            return "Pitch Bend: \(value) on \(channel)"
        case .channelPressure(let channel, let pressure):
            return "Channel Pressure: \(pressure) on \(channel)"
        case .polyPressure(let channel, let note, let pressure):
            return "Poly Pressure: \(note) = \(pressure) on \(channel)"
        case .sysex(let data):
            return "SysEx: \(data.count) bytes"
        }
    }
}
