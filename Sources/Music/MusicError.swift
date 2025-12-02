/// Errors that can occur during music theory operations
public enum MusicError: Error, Sendable {
    /// An invalid interval was specified
    case invalidInterval(String)

    /// An invalid note was specified
    case invalidNote(String)

    /// An invalid chord was specified
    case invalidChord(String)

    /// An invalid MIDI value was specified
    case invalidMIDI(String)

    /// An invalid scale was specified
    case invalidScale(String)

    /// An invalid rhythm value was specified
    case invalidRhythm(String)

    /// An operation is out of range
    case outOfRange(String)

    /// A parsing error occurred
    case parsingError(String)
}

extension MusicError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidInterval(let message):
            return "Invalid interval: \(message)"
        case .invalidNote(let message):
            return "Invalid note: \(message)"
        case .invalidChord(let message):
            return "Invalid chord: \(message)"
        case .invalidMIDI(let message):
            return "Invalid MIDI: \(message)"
        case .invalidScale(let message):
            return "Invalid scale: \(message)"
        case .invalidRhythm(let message):
            return "Invalid rhythm: \(message)"
        case .outOfRange(let message):
            return "Out of range: \(message)"
        case .parsingError(let message):
            return "Parsing error: \(message)"
        }
    }
}
