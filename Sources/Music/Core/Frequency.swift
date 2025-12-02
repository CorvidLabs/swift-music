import Foundation

/// Utilities for working with musical frequencies
public enum Frequency {
    /// Standard tuning reference frequency (A4 = 440 Hz)
    public static let standardTuning: Double = 440.0

    /// Converts a MIDI note number to frequency in Hz
    /// - Parameter midiNumber: The MIDI note number (0-127)
    /// - Returns: The frequency in Hz
    public static func fromMIDI(_ midiNumber: Int) -> Double {
        let a4MIDI = 69.0
        return standardTuning * pow(2.0, (Double(midiNumber) - a4MIDI) / 12.0)
    }

    /// Converts a frequency to the nearest MIDI note number
    /// - Parameter frequency: The frequency in Hz
    /// - Returns: The nearest MIDI note number
    public static func toMIDI(_ frequency: Double) -> Int {
        let a4MIDI = 69.0
        let midiNumber = 12.0 * log2(frequency / standardTuning) + a4MIDI
        return Int(round(midiNumber))
    }

    /// Converts a frequency to the nearest note
    /// - Parameter frequency: The frequency in Hz
    /// - Returns: The nearest note
    public static func toNote(_ frequency: Double) -> Note {
        Note.fromMIDI(toMIDI(frequency))
    }

    /// Calculates the difference in cents between two frequencies
    ///
    /// Cents are a logarithmic unit of measure used for musical intervals.
    /// 100 cents equals one semitone.
    ///
    /// - Parameters:
    ///   - frequency1: The first frequency in Hz
    ///   - frequency2: The second frequency in Hz
    /// - Returns: The difference in cents
    public static func cents(from frequency1: Double, to frequency2: Double) -> Double {
        1200.0 * log2(frequency2 / frequency1)
    }

    /// Calculates the cents deviation from the nearest equal temperament pitch
    /// - Parameter frequency: The frequency in Hz
    /// - Returns: The deviation in cents (-50 to +50)
    public static func centsDeviation(_ frequency: Double) -> Double {
        let nearestMIDI = toMIDI(frequency)
        let nearestFrequency = fromMIDI(nearestMIDI)
        return cents(from: nearestFrequency, to: frequency)
    }

    /// Converts a MIDI note number and cent deviation to frequency
    /// - Parameters:
    ///   - midiNumber: The MIDI note number
    ///   - cents: The cent deviation
    /// - Returns: The frequency in Hz
    public static func fromMIDI(_ midiNumber: Int, cents: Double) -> Double {
        let baseFrequency = fromMIDI(midiNumber)
        return baseFrequency * pow(2.0, cents / 1200.0)
    }
}
