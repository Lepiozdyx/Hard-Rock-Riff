import Foundation

enum MoodSound: String, Codable, CaseIterable {
    case distortion
    case cleanTone
    case breakdown
}

enum KeyMode: String, Codable, CaseIterable {
    case major
    case minor
}

enum ChordModifier: String, Codable, CaseIterable {
    case palmMute = "PM"
    case slide = "SL"
    case harmonic = "H"
    case bend = "B"
    case tap = "T"
}

struct ChordToken: Codable, Equatable, Identifiable {
    let id: UUID
    var chord: String
    var modifier: ChordModifier?

    init(id: UUID = UUID(), chord: String, modifier: ChordModifier? = nil) {
        self.id = id
        self.chord = chord
        self.modifier = modifier
    }

    var displayTitle: String {
        guard let modifier else { return chord }
        return "[\(modifier.rawValue)] \(chord)"
    }
}

struct RiffEntry: Codable, Equatable, Identifiable {
    let id: UUID
    var title: String
    var keyRoot: String
    var keyMode: KeyMode
    var bpm: Int
    var note: String
    var chords: [ChordToken]
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        keyRoot: String,
        keyMode: KeyMode,
        bpm: Int,
        note: String,
        chords: [ChordToken],
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.keyRoot = keyRoot
        self.keyMode = keyMode
        self.bpm = bpm
        self.note = note
        self.chords = chords
        self.createdAt = createdAt
    }

    var tonalDisplay: String {
        "\(keyRoot) \(keyMode.rawValue)"
    }
}

struct MoodEntry: Codable, Equatable, Identifiable {
    let id: UUID
    var sound: MoodSound
    var text: String
    var createdAt: Date

    init(id: UUID = UUID(), sound: MoodSound, text: String, createdAt: Date = .now) {
        self.id = id
        self.sound = sound
        self.text = text
        self.createdAt = createdAt
    }
}

@MainActor
final class AppDataStore: ObservableObject {
    @Published private(set) var riffs: [RiffEntry] = []
    @Published private(set) var moods: [MoodEntry] = []
    @Published var selectedMonth: Date = .now
    @Published var selectedDate: Date = .now

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let riffsKey = "hardrock.riffs.v1"
    private let moodsKey = "hardrock.moods.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func addRiff(_ riff: RiffEntry) {
        riffs.insert(riff, at: 0)
        saveRiffs()
    }

    func updateRiff(_ riff: RiffEntry) {
        guard let idx = riffs.firstIndex(where: { $0.id == riff.id }) else { return }
        riffs[idx] = riff
        saveRiffs()
    }

    func deleteRiff(id: UUID) {
        riffs.removeAll { $0.id == id }
        saveRiffs()
    }

    func addMood(_ mood: MoodEntry) {
        moods.insert(mood, at: 0)
        saveMoods()
    }

    func entriesExist(in month: Date) -> Bool {
        let cal = Calendar.current
        let hasRiffs = riffs.contains { cal.isDate($0.createdAt, equalTo: month, toGranularity: .month) }
        let hasMoods = moods.contains { cal.isDate($0.createdAt, equalTo: month, toGranularity: .month) }
        return hasRiffs || hasMoods
    }

    func moods(in month: Date) -> [MoodEntry] {
        let cal = Calendar.current
        return moods.filter { cal.isDate($0.createdAt, equalTo: month, toGranularity: .month) }
    }

    func riffs(in month: Date) -> [RiffEntry] {
        let cal = Calendar.current
        return riffs.filter { cal.isDate($0.createdAt, equalTo: month, toGranularity: .month) }
    }

    private func load() {
        if let data = defaults.data(forKey: riffsKey),
           let decoded = try? decoder.decode([RiffEntry].self, from: data) {
            riffs = decoded.sorted(by: { $0.createdAt > $1.createdAt })
        }

        if let data = defaults.data(forKey: moodsKey),
           let decoded = try? decoder.decode([MoodEntry].self, from: data) {
            moods = decoded.sorted(by: { $0.createdAt > $1.createdAt })
        }
    }

    private func saveRiffs() {
        guard let data = try? encoder.encode(riffs) else { return }
        defaults.set(data, forKey: riffsKey)
    }

    private func saveMoods() {
        guard let data = try? encoder.encode(moods) else { return }
        defaults.set(data, forKey: moodsKey)
    }
}

enum ChordLibrary {
    static let power: [String] = [
        "A5", "B5", "C5", "D5", "E5", "F5", "G5", "Ab5", "Bb5", "Db5", "Eb5", "Gb5"
    ]

    static let openBarre: [String] = [
        "Am", "Em", "Dm", "G", "C", "E", "A", "D", "F", "Bm", "F#m", "C#m"
    ]

    static let extended: [String] = [
        "Asus2", "Esus4", "Dsus2", "Gadd9", "Cmaj7", "Am7", "Em9", "F#m7b5", "Bdim", "E7", "A7", "D7"
    ]

    static let all: [String] = power + openBarre + extended
}

