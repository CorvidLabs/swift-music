import Testing
@testable import Music

@Suite("Rhythm")
struct RhythmTests {
    // MARK: - Note Duration Tests

    @Test("Note duration relative values")
    func noteDurationRelativeValues() {
        #expect(NoteDuration.whole.relativeDuration == 1.0)
        #expect(NoteDuration.half.relativeDuration == 0.5)
        #expect(NoteDuration.quarter.relativeDuration == 0.25)
        #expect(NoteDuration.eighth.relativeDuration == 0.125)
        #expect(NoteDuration.sixteenth.relativeDuration == 0.0625)
    }

    @Test("Dotted note duration")
    func dottedNoteDuration() {
        let dottedQuarter = NoteDuration.quarter.dotted
        #expect(abs(dottedQuarter - 0.375) < 0.001) // 0.25 * 1.5

        let dottedHalf = NoteDuration.half.dotted
        #expect(abs(dottedHalf - 0.75) < 0.001) // 0.5 * 1.5
    }

    @Test("Double dotted note duration")
    func doubleDottedNoteDuration() {
        let doubleDottedQuarter = NoteDuration.quarter.doubleDotted
        #expect(abs(doubleDottedQuarter - 0.4375) < 0.001) // 0.25 * 1.75
    }

    @Test("Triplet note duration")
    func tripletNoteDuration() {
        let tripletQuarter = NoteDuration.quarter.triplet
        // Three triplet quarters = two regular quarters
        #expect(abs(tripletQuarter * 3 - NoteDuration.half.relativeDuration) < 0.001)
    }

    @Test("Note duration display names")
    func noteDurationDisplayNames() {
        #expect(NoteDuration.whole.displayName == "Whole")
        #expect(NoteDuration.half.displayName == "Half")
        #expect(NoteDuration.quarter.displayName == "Quarter")
        #expect(NoteDuration.eighth.displayName == "Eighth")
        #expect(NoteDuration.sixteenth.displayName == "Sixteenth")
    }

    @Test("Note duration symbols")
    func noteDurationSymbols() {
        #expect(NoteDuration.quarter.symbol == "♩")
        #expect(NoteDuration.eighth.symbol == "♪")
        #expect(!NoteDuration.whole.symbol.isEmpty)
    }

    @Test("Note duration case iterable")
    func noteDurationCaseIterable() {
        let allDurations = NoteDuration.allCases
        #expect(allDurations.count == 7)
        #expect(allDurations.contains(.whole))
        #expect(allDurations.contains(.sixtyFourth))
    }

    // MARK: - Tempo Tests

    @Test("Tempo creation")
    func tempoCreation() {
        let tempo = Tempo(bpm: 120)
        #expect(tempo.bpm == 120)
    }

    @Test("Tempo beat duration")
    func tempoBeatDuration() {
        let tempo = Tempo(bpm: 60)
        #expect(abs(tempo.beatDuration - 1.0) < 0.001) // 60 BPM = 1 second per beat

        let tempo120 = Tempo(bpm: 120)
        #expect(abs(tempo120.beatDuration - 0.5) < 0.001) // 120 BPM = 0.5 seconds per beat
    }

    @Test("Tempo presets")
    func tempoPresets() {
        #expect(Tempo.largo.bpm == 50)
        #expect(Tempo.andante.bpm == 90)
        #expect(Tempo.allegro.bpm == 130)
        #expect(Tempo.presto.bpm == 180)
    }

    @Test("Tempo duration calculation")
    func tempoDurationCalculation() {
        let tempo = Tempo(bpm: 120) // 0.5 seconds per beat

        // At 120 BPM, quarter note (1 beat) = 0.5 seconds
        let quarterDuration = tempo.duration(of: .quarter)
        #expect(abs(quarterDuration - 0.5) < 0.001)

        // At 120 BPM, whole note (4 beats) = 2.0 seconds
        let wholeDuration = tempo.duration(of: .whole)
        #expect(abs(wholeDuration - 2.0) < 0.001)

        // At 120 BPM, half note (2 beats) = 1.0 seconds
        let halfDuration = tempo.duration(of: .half)
        #expect(abs(halfDuration - 1.0) < 0.001)
    }

    @Test("Tempo relative duration calculation")
    func tempoRelativeDurationCalculation() {
        let tempo = Tempo(bpm: 120)

        // Dotted quarter (1.5 beats) = 0.75 seconds at 120 BPM
        let dottedQuarterDuration = tempo.duration(relativeDuration: NoteDuration.quarter.dotted)
        #expect(abs(dottedQuarterDuration - 0.75) < 0.001)
    }

    @Test("Tempo comparison")
    func tempoComparison() {
        #expect(Tempo.largo < Tempo.allegro)
        #expect(Tempo.presto > Tempo.andante)
    }

    @Test("Tempo equality")
    func tempoEquality() {
        let t1 = Tempo(bpm: 120)
        let t2 = Tempo(bpm: 120)
        let t3 = Tempo(bpm: 100)

        #expect(t1 == t2)
        #expect(t1 != t3)
    }

    @Test("Tempo description")
    func tempoDescription() {
        let tempo = Tempo(bpm: 120)
        #expect(tempo.description == "120 BPM")
    }

    // MARK: - Tempo Marking Tests

    @Test("Tempo marking BPM ranges")
    func tempoMarkingBPMRanges() {
        #expect(TempoMarking.largo.bpmRange == 40...60)
        #expect(TempoMarking.allegro.bpmRange == 120...140)
        #expect(TempoMarking.presto.bpmRange == 160...200)
    }

    @Test("Tempo marking typical tempo")
    func tempoMarkingTypicalTempo() {
        let moderatoTempo = TempoMarking.moderato.typicalTempo
        #expect(moderatoTempo.bpm == 110) // midpoint of 100-120
    }

    @Test("Tempo marking case iterable")
    func tempoMarkingCaseIterable() {
        let allMarkings = TempoMarking.allCases
        #expect(allMarkings.count == 11)
        #expect(allMarkings.contains(.grave))
        #expect(allMarkings.contains(.prestissimo))
    }

    // MARK: - Time Signature Tests

    @Test("Time signature creation")
    func timeSignatureCreation() {
        let fourFour = TimeSignature(beats: 4, noteValue: 4)
        #expect(fourFour.beats == 4)
        #expect(fourFour.noteValue == 4)
    }

    @Test("Common time signatures")
    func commonTimeSignatures() {
        let fourFour = TimeSignature.fourFour
        #expect(fourFour.beats == 4)
        #expect(fourFour.noteValue == 4)

        let threeFour = TimeSignature.threeFour
        #expect(threeFour.beats == 3)
        #expect(threeFour.noteValue == 4)

        let sixEight = TimeSignature.sixEight
        #expect(sixEight.beats == 6)
        #expect(sixEight.noteValue == 8)
    }

    @Test("Time signature aliases")
    func timeSignatureAliases() {
        #expect(TimeSignature.commonTime == TimeSignature.fourFour)
        #expect(TimeSignature.waltzTime == TimeSignature.threeFour)
        #expect(TimeSignature.marchTime == TimeSignature.twoFour)
        #expect(TimeSignature.cutTime == TimeSignature.twoTwo)
    }

    @Test("Time signature display")
    func timeSignatureDisplay() {
        #expect(TimeSignature.fourFour.display == "4/4")
        #expect(TimeSignature.sixEight.display == "6/8")
        #expect(TimeSignature.threeFour.display == "3/4")
    }

    @Test("Time signature description")
    func timeSignatureDescription() {
        #expect(TimeSignature.fourFour.description == "4/4")
        #expect(TimeSignature.sixEight.description == "6/8")
    }

    @Test("Time signature is compound")
    func isCompoundMeter() {
        #expect(TimeSignature.sixEight.isCompound)
        #expect(TimeSignature.nineEight.isCompound)
        #expect(TimeSignature.twelveEight.isCompound)

        #expect(!TimeSignature.fourFour.isCompound)
        #expect(!TimeSignature.threeFour.isCompound)
        #expect(!TimeSignature.threeEight.isCompound) // 3 is not > 3
    }

    @Test("Time signature is simple")
    func isSimpleMeter() {
        #expect(TimeSignature.fourFour.isSimple)
        #expect(TimeSignature.threeFour.isSimple)
        #expect(TimeSignature.twoFour.isSimple)

        #expect(!TimeSignature.sixEight.isSimple)
    }

    @Test("Time signature strong beats")
    func timeSignatureStrongBeats() {
        #expect(TimeSignature.fourFour.strongBeats == [1, 3])
        #expect(TimeSignature.threeFour.strongBeats == [1])
        #expect(TimeSignature.twoFour.strongBeats == [1])
        #expect(TimeSignature.sixEight.strongBeats == [1, 4])
    }

    @Test("Time signature equality")
    func timeSignatureEquality() {
        let ts1 = TimeSignature(beats: 4, noteValue: 4)
        let ts2 = TimeSignature(beats: 4, noteValue: 4)
        let ts3 = TimeSignature(beats: 3, noteValue: 4)

        #expect(ts1 == ts2)
        #expect(ts1 != ts3)
    }

    @Test("Time signature hashable")
    func timeSignatureHashable() {
        var set = Set<TimeSignature>()
        set.insert(TimeSignature.fourFour)
        set.insert(TimeSignature.fourFour)
        set.insert(TimeSignature.sixEight)

        #expect(set.count == 2)
    }

    @Test("Common time signatures collection")
    func commonTimeSignaturesCollection() {
        let common = TimeSignature.commonTimeSignatures
        #expect(common.count == 11)
        #expect(common.contains(.fourFour))
        #expect(common.contains(.sixEight))
    }
}
