import Foundation

/// Represents a MIDI track containing events
///
/// A MIDI track is a sequence of events that can represent a single
/// instrument or part in a composition.
public struct MIDITrack: Sendable {
    /// The name of the track
    public let name: String

    /// The events in this track
    public private(set) var events: [MIDIEvent]

    /// Creates a MIDI track
    /// - Parameters:
    ///   - name: The name of the track
    ///   - events: The events in the track (default: empty)
    public init(name: String, events: [MIDIEvent] = []) {
        self.name = name
        self.events = events
    }

    /// Adds a note with start and end times
    /// - Parameters:
    ///   - note: The MIDI note
    ///   - channel: The MIDI channel
    ///   - startTick: The start tick
    ///   - duration: The duration in ticks
    ///   - velocity: The velocity (default: mf)
    public mutating func addNote(
        _ note: MIDINote,
        channel: MIDIChannel,
        startTick: UInt32,
        duration: UInt32,
        velocity: MIDIVelocity = .mf
    ) {
        let noteOn = MIDIEvent.noteOn(
            tick: startTick,
            channel: channel,
            note: note,
            velocity: velocity
        )

        let noteOff = MIDIEvent.noteOff(
            tick: startTick + duration,
            channel: channel,
            note: note
        )

        events.append(noteOn)
        events.append(noteOff)
    }

    /// Adds an event to the track
    /// - Parameter event: The event to add
    public mutating func addEvent(_ event: MIDIEvent) {
        events.append(event)
    }

    /// Sorts the events by tick time
    public mutating func sort() {
        events.sort()
    }

    /// Returns a new track with sorted events
    /// - Returns: A new track with sorted events
    public func sorted() -> MIDITrack {
        var copy = self
        copy.sort()
        return copy
    }

    /// The total duration of the track in ticks
    public var duration: UInt32 {
        events.map { $0.tick }.max() ?? 0
    }

    /// Filters events by a predicate
    /// - Parameter predicate: The predicate to filter by
    /// - Returns: A new track with filtered events
    public func filter(_ predicate: (MIDIEvent) -> Bool) -> MIDITrack {
        MIDITrack(name: name, events: events.filter(predicate))
    }

    /// Returns events in a specific tick range
    /// - Parameter range: The tick range
    /// - Returns: A new track with events in the range
    public func events(in range: ClosedRange<UInt32>) -> MIDITrack {
        filter { range.contains($0.tick) }
    }
}

extension MIDITrack: Equatable {
    public static func == (lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        lhs.name == rhs.name && lhs.events == rhs.events
    }
}

extension MIDITrack: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(events)
    }
}

extension MIDITrack: CustomStringConvertible {
    public var description: String {
        "\(name): \(events.count) events"
    }
}
