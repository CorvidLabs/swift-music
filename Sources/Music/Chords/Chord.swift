/**
 Represents a musical chord

 A chord combines a root note, quality, optional extensions,
 and optional bass note to define a harmonic structure.
 */
public struct Chord: Sendable {
    /// The root pitch class of the chord
    public let root: PitchClass

    /// The quality of the chord
    public let quality: ChordQuality

    /// Optional extensions and alterations
    public let extensions: ChordExtension

    /// Optional bass note (for slash chords)
    public let bass: PitchClass?

    /**
     Creates a chord

     - Parameters:
       - root: The root pitch class
       - quality: The chord quality
       - extensions: Optional extensions (default: none)
       - bass: Optional bass note for slash chords (default: nil)
     */
    public init(
        root: PitchClass,
        quality: ChordQuality,
        extensions: ChordExtension = [],
        bass: PitchClass? = nil
    ) {
        self.root = root
        self.quality = quality
        self.extensions = extensions
        self.bass = bass
    }

    /// The pitch classes in this chord (without considering octaves)
    public var pitchClasses: [PitchClass] {
        let baseIntervals = quality.intervals + extensions.intervals
        var classes = baseIntervals.map { interval in
            root.transposed(by: interval % 12)
        }

        // Add bass note if different from root
        if let bass = bass, bass != root {
            classes.insert(bass, at: 0)
        }

        // Remove duplicates while preserving order
        var seen = Set<PitchClass>()
        return classes.filter { pitchClass in
            if seen.contains(pitchClass) {
                return false
            } else {
                seen.insert(pitchClass)
                return true
            }
        }
    }

    /**
     Generates notes for this chord in a specific octave

     - Parameter octave: The octave for the root note
     - Returns: Array of notes in the chord
     */
    public func notes(octave: Int) -> [Note] {
        let baseIntervals = quality.intervals + extensions.intervals

        var notes = baseIntervals.map { interval in
            let semitones = interval
            let octaveOffset = semitones / 12
            let pitchClass = root.transposed(by: semitones % 12)
            return Note(pitchClass: pitchClass, octave: octave + octaveOffset)
        }

        // Handle bass note
        if let bass = bass, bass != root {
            let bassNote = Note(pitchClass: bass, octave: octave - 1)
            notes.insert(bassNote, at: 0)
        }

        return notes
    }

    /**
     Returns an inversion of this chord

     - Parameter inversion: The inversion number (0 = root position, 1 = first inversion, etc.)
     - Returns: The inverted chord
     */
    public func inversion(_ inversion: Int) -> Chord {
        let noteCount = quality.intervals.count
        guard inversion > 0 && inversion < noteCount else {
            return self
        }

        let bassIndex = inversion % noteCount
        let newBass = root.transposed(by: quality.intervals[bassIndex])

        return Chord(
            root: root,
            quality: quality,
            extensions: extensions,
            bass: newBass
        )
    }

    /// The chord symbol
    public var symbol: String {
        var result = root.displayName + quality.symbol

        if !extensions.isEmpty {
            result += " " + extensions.symbol
        }

        if let bass = bass, bass != root {
            result += "/" + bass.displayName
        }

        return result
    }

    // MARK: - Common Chords

    /// C major chord
    public static let cMajor = Chord(root: .c, quality: .major)

    /// C minor chord
    public static let cMinor = Chord(root: .c, quality: .minor)

    /// G major chord
    public static let gMajor = Chord(root: .g, quality: .major)

    /// F major chord
    public static let fMajor = Chord(root: .f, quality: .major)

    /// A minor chord
    public static let aMinor = Chord(root: .a, quality: .minor)

    /// D minor chord
    public static let dMinor = Chord(root: .d, quality: .minor)

    /// E minor chord
    public static let eMinor = Chord(root: .e, quality: .minor)

    /// G7 chord
    public static let g7 = Chord(root: .g, quality: .dominant7)
}

extension Chord: Equatable {
    public static func == (lhs: Chord, rhs: Chord) -> Bool {
        lhs.root == rhs.root &&
        lhs.quality == rhs.quality &&
        lhs.extensions == rhs.extensions &&
        lhs.bass == rhs.bass
    }
}

extension Chord: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(root)
        hasher.combine(quality)
        hasher.combine(extensions)
        hasher.combine(bass)
    }
}

extension Chord: CustomStringConvertible {
    public var description: String {
        symbol
    }
}
