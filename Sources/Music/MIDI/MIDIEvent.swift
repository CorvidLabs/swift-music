/**
 Represents a MIDI event with timing information

 A MIDI event combines a MIDI message with a timestamp (tick).
 */
public struct MIDIEvent: Sendable {
    /// The tick (timing) of this event
    public let tick: UInt32

    /// The MIDI message
    public let message: MIDIMessage

    /**
     Creates a MIDI event

     - Parameters:
       - tick: The tick (timing) of the event
       - message: The MIDI message
     */
    public init(tick: UInt32, message: MIDIMessage) {
        self.tick = tick
        self.message = message
    }

    /**
     Creates a note on event

     - Parameters:
       - tick: The tick (timing) of the event
       - channel: The MIDI channel
       - note: The MIDI note
       - velocity: The velocity
     - Returns: A MIDI event with a note on message
     */
    public static func noteOn(
        tick: UInt32,
        channel: MIDIChannel,
        note: MIDINote,
        velocity: MIDIVelocity
    ) -> MIDIEvent {
        MIDIEvent(
            tick: tick,
            message: .noteOn(channel: channel, note: note, velocity: velocity)
        )
    }

    /**
     Creates a note off event

     - Parameters:
       - tick: The tick (timing) of the event
       - channel: The MIDI channel
       - note: The MIDI note
       - velocity: The velocity
     - Returns: A MIDI event with a note off message
     */
    public static func noteOff(
        tick: UInt32,
        channel: MIDIChannel,
        note: MIDINote,
        velocity: MIDIVelocity = .silent
    ) -> MIDIEvent {
        MIDIEvent(
            tick: tick,
            message: .noteOff(channel: channel, note: note, velocity: velocity)
        )
    }
}

extension MIDIEvent: Equatable {
    public static func == (lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        lhs.tick == rhs.tick && lhs.message == rhs.message
    }
}

extension MIDIEvent: Comparable {
    public static func < (lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        lhs.tick < rhs.tick
    }
}

extension MIDIEvent: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(tick)
        hasher.combine(message)
    }
}

extension MIDIEvent: CustomStringConvertible {
    public var description: String {
        "[\(tick)] \(message)"
    }
}
