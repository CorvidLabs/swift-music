import Foundation

/// Represents a MIDI file
///
/// MIDI files store musical data in a standardized format that can be
/// played back by any MIDI-compatible software or hardware.
public struct MIDIFile: Sendable {
    /// MIDI file format type
    public enum Format: UInt16, Sendable {
        /// Format 0: Single track
        case single = 0

        /// Format 1: Multiple tracks, synchronous
        case multiTrack = 1

        /// Format 2: Multiple tracks, asynchronous
        case multiSequence = 2
    }

    /// The format of the MIDI file
    public let format: Format

    /// Ticks per quarter note (resolution)
    public let ticksPerQuarterNote: UInt16

    /// The tracks in the MIDI file
    public private(set) var tracks: [MIDITrack]

    /// Creates a MIDI file
    /// - Parameters:
    ///   - format: The MIDI file format (default: .multiTrack)
    ///   - ticksPerQuarterNote: The resolution in ticks per quarter note (default: 480)
    ///   - tracks: The tracks in the file (default: empty)
    public init(
        format: Format = .multiTrack,
        ticksPerQuarterNote: UInt16 = 480,
        tracks: [MIDITrack] = []
    ) {
        self.format = format
        self.ticksPerQuarterNote = ticksPerQuarterNote
        self.tracks = tracks
    }

    /// Adds a track to the file
    /// - Parameter track: The track to add
    public mutating func addTrack(_ track: MIDITrack) {
        tracks.append(track)
    }

    /// Encodes the MIDI file to binary data
    /// - Returns: The MIDI file data
    /// - Throws: MusicError if encoding fails
    public func encode() throws -> Data {
        var data = Data()

        // Write header chunk
        data.append(contentsOf: "MThd".utf8)
        data.append(contentsOf: UInt32(6).bigEndianBytes)
        data.append(contentsOf: format.rawValue.bigEndianBytes)
        data.append(contentsOf: UInt16(tracks.count).bigEndianBytes)
        data.append(contentsOf: ticksPerQuarterNote.bigEndianBytes)

        // Write track chunks
        for track in tracks {
            let trackData = try encodeTrack(track)
            data.append(contentsOf: "MTrk".utf8)
            data.append(contentsOf: UInt32(trackData.count).bigEndianBytes)
            data.append(trackData)
        }

        return data
    }

    /// Decodes a MIDI file from binary data
    /// - Parameter data: The MIDI file data
    /// - Returns: The decoded MIDI file
    /// - Throws: MusicError if decoding fails
    public static func decode(from data: Data) throws -> MIDIFile {
        var reader = DataReader(data: data)

        // Read header chunk
        let headerID = try reader.readString(length: 4)
        guard headerID == "MThd" else {
            throw MusicError.parsingError("Invalid MIDI file: expected 'MThd', got '\(headerID)'")
        }

        let headerLength = try reader.readUInt32()
        guard headerLength == 6 else {
            throw MusicError.parsingError("Invalid header length: \(headerLength)")
        }

        let formatValue = try reader.readUInt16()
        guard let format = Format(rawValue: formatValue) else {
            throw MusicError.parsingError("Invalid MIDI format: \(formatValue)")
        }

        let trackCount = try reader.readUInt16()
        let ticksPerQuarterNote = try reader.readUInt16()

        // Read tracks
        var tracks: [MIDITrack] = []
        for trackIndex in 0..<Int(trackCount) {
            let trackID = try reader.readString(length: 4)
            guard trackID == "MTrk" else {
                throw MusicError.parsingError("Invalid track header: expected 'MTrk', got '\(trackID)'")
            }

            let trackLength = try reader.readUInt32()
            let trackData = try reader.readData(length: Int(trackLength))
            let track = try decodeTrack(trackData, index: trackIndex)
            tracks.append(track)
        }

        return MIDIFile(
            format: format,
            ticksPerQuarterNote: ticksPerQuarterNote,
            tracks: tracks
        )
    }

    // MARK: - Private Encoding/Decoding

    private func encodeTrack(_ track: MIDITrack) throws -> Data {
        var data = Data()
        var lastTick: UInt32 = 0

        // Add track name as meta event
        if !track.name.isEmpty {
            data.append(contentsOf: encodeVariableLength(0)) // delta time
            data.append(0xFF) // meta event
            data.append(0x03) // track name
            let nameData = Data(track.name.utf8)
            data.append(contentsOf: encodeVariableLength(UInt32(nameData.count)))
            data.append(nameData)
        }

        // Encode events
        let sortedEvents = track.events.sorted()
        for event in sortedEvents {
            let deltaTime = event.tick - lastTick
            data.append(contentsOf: encodeVariableLength(deltaTime))
            data.append(contentsOf: event.message.bytes)
            lastTick = event.tick
        }

        // End of track
        data.append(contentsOf: encodeVariableLength(0))
        data.append(0xFF) // meta event
        data.append(0x2F) // end of track
        data.append(0x00) // length

        return data
    }

    private static func decodeTrack(_ data: Data, index: Int) throws -> MIDITrack {
        var reader = DataReader(data: data)
        var events: [MIDIEvent] = []
        var currentTick: UInt32 = 0
        var runningStatus: UInt8 = 0
        var trackName = "Track \(index + 1)"

        while reader.position < data.count {
            let deltaTime = try reader.readVariableLength()
            currentTick += deltaTime

            var statusByte = try reader.readUInt8()

            // Handle running status
            if statusByte < 0x80 {
                reader.position -= 1 // put the byte back
                statusByte = runningStatus
            } else {
                runningStatus = statusByte
            }

            // Meta event
            if statusByte == 0xFF {
                let metaType = try reader.readUInt8()
                let length = try reader.readVariableLength()

                if metaType == 0x03 { // Track name
                    let nameData = try reader.readData(length: Int(length))
                    trackName = String(data: nameData, encoding: .utf8) ?? trackName
                } else if metaType == 0x2F { // End of track
                    break
                } else {
                    // Skip other meta events
                    reader.position += Int(length)
                }
                continue
            }

            // System exclusive
            if statusByte == 0xF0 || statusByte == 0xF7 {
                let length = try reader.readVariableLength()
                let sysexData = try reader.readData(length: Int(length))
                let message = MIDIMessage.sysex(data: Array(sysexData))
                events.append(MIDIEvent(tick: currentTick, message: message))
                continue
            }

            // Regular MIDI message
            let messageLength = messageLengthForStatus(statusByte)
            reader.position -= 1 // include status byte
            let messageBytes = try reader.readData(length: messageLength)
            let message = try MIDIMessage.parse(Array(messageBytes))
            events.append(MIDIEvent(tick: currentTick, message: message))
        }

        return MIDITrack(name: trackName, events: events)
    }

    private static func messageLengthForStatus(_ status: UInt8) -> Int {
        let type = status & 0xF0
        switch type {
        case 0x80, 0x90, 0xA0, 0xB0, 0xE0:
            return 3
        case 0xC0, 0xD0:
            return 2
        default:
            return 1
        }
    }
}

// MARK: - Variable Length Encoding

private func encodeVariableLength(_ value: UInt32) -> [UInt8] {
    var bytes: [UInt8] = []
    var val = value

    bytes.append(UInt8(val & 0x7F))
    val >>= 7

    while val > 0 {
        bytes.insert(UInt8((val & 0x7F) | 0x80), at: 0)
        val >>= 7
    }

    return bytes
}

// MARK: - Data Reader Helper

private struct DataReader {
    let data: Data
    var position: Int = 0

    mutating func readUInt8() throws -> UInt8 {
        guard position < data.count else {
            throw MusicError.parsingError("Unexpected end of data")
        }
        let value = data[position]
        position += 1
        return value
    }

    mutating func readUInt16() throws -> UInt16 {
        let byte1 = try readUInt8()
        let byte2 = try readUInt8()
        return (UInt16(byte1) << 8) | UInt16(byte2)
    }

    mutating func readUInt32() throws -> UInt32 {
        let byte1 = try readUInt8()
        let byte2 = try readUInt8()
        let byte3 = try readUInt8()
        let byte4 = try readUInt8()
        return (UInt32(byte1) << 24) | (UInt32(byte2) << 16) | (UInt32(byte3) << 8) | UInt32(byte4)
    }

    mutating func readString(length: Int) throws -> String {
        let stringData = try readData(length: length)
        guard let string = String(data: stringData, encoding: .ascii) else {
            throw MusicError.parsingError("Invalid ASCII string")
        }
        return string
    }

    mutating func readData(length: Int) throws -> Data {
        guard position + length <= data.count else {
            throw MusicError.parsingError("Unexpected end of data")
        }
        let range = position..<(position + length)
        let subdata = data.subdata(in: range)
        position += length
        return subdata
    }

    mutating func readVariableLength() throws -> UInt32 {
        var value: UInt32 = 0
        var byte: UInt8

        repeat {
            byte = try readUInt8()
            value = (value << 7) | UInt32(byte & 0x7F)
        } while (byte & 0x80) != 0

        return value
    }
}

// MARK: - Big Endian Helpers

extension UInt16 {
    fileprivate var bigEndianBytes: [UInt8] {
        let bigEndian = self.bigEndian
        return [
            UInt8((bigEndian >> 8) & 0xFF),
            UInt8(bigEndian & 0xFF)
        ]
    }
}

extension UInt32 {
    fileprivate var bigEndianBytes: [UInt8] {
        let bigEndian = self.bigEndian
        return [
            UInt8((bigEndian >> 24) & 0xFF),
            UInt8((bigEndian >> 16) & 0xFF),
            UInt8((bigEndian >> 8) & 0xFF),
            UInt8(bigEndian & 0xFF)
        ]
    }
}

extension MIDIFile: Equatable {
    public static func == (lhs: MIDIFile, rhs: MIDIFile) -> Bool {
        lhs.format == rhs.format &&
        lhs.ticksPerQuarterNote == rhs.ticksPerQuarterNote &&
        lhs.tracks == rhs.tracks
    }
}

extension MIDIFile: CustomStringConvertible {
    public var description: String {
        "MIDI File (\(format), \(ticksPerQuarterNote) TPQN, \(tracks.count) tracks)"
    }
}
