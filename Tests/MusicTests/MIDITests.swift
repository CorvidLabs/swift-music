import Foundation
import Testing
@testable import Music

@Suite("MIDI")
struct MIDITests {
    // MARK: - MIDINote Tests

    @Test("MIDI note valid range")
    func midiNoteValidRange() throws {
        let note0 = try MIDINote(0)
        let note127 = try MIDINote(127)
        #expect(note0.value == 0)
        #expect(note127.value == 127)
    }

    @Test("MIDI note invalid range throws")
    func midiNoteInvalidRange() {
        #expect(throws: MusicError.self) {
            _ = try MIDINote(128)
        }
    }

    // MARK: - MIDIVelocity Tests

    @Test("MIDI velocity valid range")
    func midiVelocityValidRange() throws {
        let vel0 = try MIDIVelocity(0)
        let vel127 = try MIDIVelocity(127)
        #expect(vel0.value == 0)
        #expect(vel127.value == 127)
    }

    @Test("MIDI velocity dynamics")
    func midiVelocityDynamics() throws {
        let pp = MIDIVelocity.pp
        let ff = MIDIVelocity.ff
        #expect(pp.value < ff.value)
        #expect(MIDIVelocity.mf.value == 80)
    }

    // MARK: - MIDIChannel Tests

    @Test("MIDI channel valid range")
    func midiChannelValidRange() throws {
        let ch0 = try MIDIChannel(0)
        let ch15 = try MIDIChannel(15)
        #expect(ch0.value == 0)
        #expect(ch15.value == 15)
    }

    @Test("MIDI channel invalid throws")
    func midiChannelInvalid() {
        #expect(throws: MusicError.self) {
            _ = try MIDIChannel(16)
        }
    }

    // MARK: - MIDIMessage Tests

    @Test("Note on message encoding")
    func noteOnEncoding() throws {
        let message = MIDIMessage.noteOn(
            channel: try MIDIChannel(0),
            note: try MIDINote(60),
            velocity: try MIDIVelocity(100)
        )
        #expect(message.bytes == [0x90, 60, 100])
    }

    @Test("Note off message encoding")
    func noteOffEncoding() throws {
        let message = MIDIMessage.noteOff(
            channel: try MIDIChannel(5),
            note: try MIDINote(72),
            velocity: try MIDIVelocity(0)
        )
        #expect(message.bytes == [0x85, 72, 0])
    }

    @Test("Control change message encoding")
    func controlChangeEncoding() throws {
        let message = MIDIMessage.controlChange(
            channel: try MIDIChannel(0),
            controller: 7, // volume
            value: 100
        )
        #expect(message.bytes == [0xB0, 7, 100])
    }

    @Test("Program change message encoding")
    func programChangeEncoding() throws {
        let message = MIDIMessage.programChange(
            channel: try MIDIChannel(0),
            program: 25
        )
        #expect(message.bytes == [0xC0, 25])
    }

    @Test("Pitch bend message encoding")
    func pitchBendEncoding() throws {
        // Center (no bend) = 0 (signed)
        let center = MIDIMessage.pitchBend(
            channel: try MIDIChannel(0),
            value: 0
        )
        #expect(center.bytes == [0xE0, 0x00, 0x40])

        // Max bend up = 8191 (signed)
        let maxUp = MIDIMessage.pitchBend(
            channel: try MIDIChannel(0),
            value: 8191
        )
        #expect(maxUp.bytes == [0xE0, 0x7F, 0x7F])

        // Max bend down = -8192 (signed)
        let maxDown = MIDIMessage.pitchBend(
            channel: try MIDIChannel(0),
            value: -8192
        )
        #expect(maxDown.bytes == [0xE0, 0x00, 0x00])
    }

    @Test("MIDI message parsing roundtrip")
    func messageParsingRoundtrip() throws {
        let messages: [MIDIMessage] = [
            .noteOn(channel: try MIDIChannel(0), note: try MIDINote(60), velocity: try MIDIVelocity(100)),
            .noteOff(channel: try MIDIChannel(3), note: try MIDINote(72), velocity: try MIDIVelocity(64)),
            .controlChange(channel: try MIDIChannel(1), controller: 64, value: 127),
            .programChange(channel: try MIDIChannel(9), program: 0),
        ]

        for original in messages {
            let parsed = try MIDIMessage.parse(original.bytes)
            #expect(parsed == original)
        }
    }

    // MARK: - MIDIEvent Tests

    @Test("MIDI event ordering")
    func midiEventOrdering() throws {
        let event1 = MIDIEvent(tick: 0, message: .noteOn(channel: try MIDIChannel(0), note: try MIDINote(60), velocity: try MIDIVelocity(100)))
        let event2 = MIDIEvent(tick: 480, message: .noteOff(channel: try MIDIChannel(0), note: try MIDINote(60), velocity: try MIDIVelocity(0)))

        #expect(event1 < event2)
    }

    // MARK: - MIDITrack Tests

    @Test("MIDI track creation")
    func midiTrackCreation() throws {
        var track = MIDITrack(name: "Test Track")
        track.addEvent(MIDIEvent(tick: 0, message: .noteOn(channel: try MIDIChannel(0), note: try MIDINote(60), velocity: try MIDIVelocity(100))))
        track.addEvent(MIDIEvent(tick: 480, message: .noteOff(channel: try MIDIChannel(0), note: try MIDINote(60), velocity: try MIDIVelocity(0))))

        #expect(track.name == "Test Track")
        #expect(track.events.count == 2)
    }

    // MARK: - MIDIFile Tests

    @Test("MIDI file creation")
    func midiFileCreation() {
        let file = MIDIFile(format: .multiTrack, ticksPerQuarterNote: 480)
        #expect(file.format == .multiTrack)
        #expect(file.ticksPerQuarterNote == 480)
        #expect(file.tracks.isEmpty)
    }

    @Test("MIDI file encode/decode roundtrip")
    func midiFileRoundtrip() throws {
        var file = MIDIFile(format: .multiTrack, ticksPerQuarterNote: 480)

        var track = MIDITrack(name: "Piano")
        track.addEvent(MIDIEvent(tick: 0, message: .noteOn(channel: try MIDIChannel(0), note: try MIDINote(60), velocity: try MIDIVelocity(100))))
        track.addEvent(MIDIEvent(tick: 480, message: .noteOff(channel: try MIDIChannel(0), note: try MIDINote(60), velocity: try MIDIVelocity(0))))
        track.addEvent(MIDIEvent(tick: 480, message: .noteOn(channel: try MIDIChannel(0), note: try MIDINote(64), velocity: try MIDIVelocity(100))))
        track.addEvent(MIDIEvent(tick: 960, message: .noteOff(channel: try MIDIChannel(0), note: try MIDINote(64), velocity: try MIDIVelocity(0))))

        file.addTrack(track)

        let encoded = try file.encode()
        let decoded = try MIDIFile.decode(from: encoded)

        #expect(decoded.format == file.format)
        #expect(decoded.ticksPerQuarterNote == file.ticksPerQuarterNote)
        #expect(decoded.tracks.count == file.tracks.count)
        #expect(decoded.tracks[0].events.count == file.tracks[0].events.count)
    }

    @Test("MIDI file with multiple tracks")
    func midiFileMultipleTracks() throws {
        var file = MIDIFile(format: .multiTrack, ticksPerQuarterNote: 480)

        var track1 = MIDITrack(name: "Melody")
        track1.addEvent(MIDIEvent(tick: 0, message: .noteOn(channel: try MIDIChannel(0), note: try MIDINote(72), velocity: try MIDIVelocity(100))))
        track1.addEvent(MIDIEvent(tick: 480, message: .noteOff(channel: try MIDIChannel(0), note: try MIDINote(72), velocity: try MIDIVelocity(0))))

        var track2 = MIDITrack(name: "Bass")
        track2.addEvent(MIDIEvent(tick: 0, message: .noteOn(channel: try MIDIChannel(1), note: try MIDINote(36), velocity: try MIDIVelocity(80))))
        track2.addEvent(MIDIEvent(tick: 960, message: .noteOff(channel: try MIDIChannel(1), note: try MIDINote(36), velocity: try MIDIVelocity(0))))

        file.addTrack(track1)
        file.addTrack(track2)

        let encoded = try file.encode()
        let decoded = try MIDIFile.decode(from: encoded)

        #expect(decoded.tracks.count == 2)
    }

    @Test("MIDI file format 0 single track")
    func midiFileSingleFormat() throws {
        var file = MIDIFile(format: .single, ticksPerQuarterNote: 96)

        var track = MIDITrack(name: "Single")
        track.addEvent(MIDIEvent(tick: 0, message: .noteOn(channel: try MIDIChannel(0), note: try MIDINote(60), velocity: try MIDIVelocity(100))))
        file.addTrack(track)

        let encoded = try file.encode()
        let decoded = try MIDIFile.decode(from: encoded)

        #expect(decoded.format == .single)
        #expect(decoded.ticksPerQuarterNote == 96)
    }

    @Test("MIDI file empty track")
    func midiFileEmptyTrack() throws {
        var file = MIDIFile()
        file.addTrack(MIDITrack(name: "Empty"))

        let encoded = try file.encode()
        let decoded = try MIDIFile.decode(from: encoded)

        #expect(decoded.tracks.count == 1)
        #expect(decoded.tracks[0].events.isEmpty)
    }

    @Test("Invalid MIDI file header throws")
    func invalidMidiHeader() {
        let invalidData = Data("NotAMIDI".utf8)
        #expect(throws: MusicError.self) {
            _ = try MIDIFile.decode(from: invalidData)
        }
    }
}
