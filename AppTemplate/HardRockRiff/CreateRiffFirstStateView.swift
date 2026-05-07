import SwiftUI
import UIKit

struct CreateRiffFirstStateView: View {
    private enum InputField {
        case title
        case note
    }

    let onOpenRiffDetails: (RiffEntry) -> Void
    let editingRiff: RiffEntry?
    let onFinishEditing: ((RiffEntry) -> Void)?
    @EnvironmentObject private var store: AppDataStore

    @State private var title: String = ""
    @State private var selectedKeyRoot: String = "E"
    @State private var selectedKeyMode: KeyMode = .minor
    @State private var bpm: Int = 120
    @State private var note: String = ""
    @State private var chords: [ChordToken] = []
    @State private var isKeyPanelExpanded = false
    @State private var isChordPanelExpanded = false
    @FocusState private var focusedField: InputField?

    private enum RiffInputLimits {
        static let titleMax = 20
        static let noteMax = 50
    }

    private static func clampTitle(_ raw: String) -> String {
        String(raw.englishSanitized().prefix(RiffInputLimits.titleMax))
    }

    private static func clampNote(_ raw: String) -> String {
        String(raw.replacingOccurrences(of: "\n", with: " ").englishSanitized().prefix(RiffInputLimits.noteMax))
    }

    init(
        onOpenRiffDetails: @escaping (RiffEntry) -> Void = { _ in },
        editingRiff: RiffEntry? = nil,
        onFinishEditing: ((RiffEntry) -> Void)? = nil
    ) {
        self.onOpenRiffDetails = onOpenRiffDetails
        self.editingRiff = editingRiff
        self.onFinishEditing = onFinishEditing
        _title = State(initialValue: Self.clampTitle(editingRiff?.title ?? ""))
        _selectedKeyRoot = State(initialValue: editingRiff?.keyRoot ?? "E")
        _selectedKeyMode = State(initialValue: editingRiff?.keyMode ?? .minor)
        _bpm = State(initialValue: editingRiff?.bpm ?? 120)
        _note = State(initialValue: Self.clampNote(editingRiff?.note ?? ""))
        _chords = State(initialValue: editingRiff?.chords ?? [])
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Image("Frame 94036-2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()

                ScrollView(showsIndicators: false) {
                    ZStack(alignment: .topLeading) {
                        Image("image 2108")
                            .resizable()
                            .frame(width: 135, height: 122)
                            .offset(x: 250, y: 66)

                        Image("image 2107-2")
                            .resizable()
                            .frame(width: 206, height: 39)
                            .offset(x: 14, y: 66)

                        Image("image 2109")
                            .resizable()
                            .frame(width: 208, height: 16)
                            .offset(x: 22, y: 111)

                        createCard
                            .frame(width: 370, height: 458)
                            .offset(x: 10, y: 131)

                        if store.riffs.isEmpty {
                            Image("Group 10")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 194)
                                .opacity(0.9)
                                .offset(x: 98, y: 602)
                        } else {
                            myRiffsPanel
                                .frame(width: 370, height: riffsPanelHeight)
                                .offset(x: 10, y: 600)
                        }
                    }
                    .frame(width: 390, height: contentHeight, alignment: .topLeading)
                    .padding(.bottom, 120)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .clipped()
    }

    private var createCard: some View {
        ZStack(alignment: .topLeading) {
            cardBackground

            Circle().fill(Color(hex: "6A46F3")).frame(width: 8, height: 8).offset(x: 15, y: 24)
            Text("Create Riff").labelStyleBebas(20).offset(x: 34, y: 18)

            riffNameField.offset(x: 15, y: 52)

            Text("KEY").labelStyleBebas(20).offset(x: 15, y: 108)
            Text("BPM").labelStyleBebas(20).offset(x: 155, y: 108)

            keyField

            field("\(bpm)", width: 80, height: 40, x: 155, y: 132, opacity: 1, size: 13)
            Image(systemName: "chevron.up")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color(hex: "5C45B7"))
                .offset(x: 216, y: 139)
                .onTapGestureWithButtonFeedback { bpm = min(220, bpm + 1) }
            Image(systemName: "chevron.down")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color(hex: "5C45B7"))
                .offset(x: 216, y: 151)
                .onTapGestureWithButtonFeedback { bpm = max(60, bpm - 1) }

            tempoBlock().offset(x: 245, y: 108)

            Text("CHORD SEQUENCE (UP TO 16 BARS)").labelStyleBebas(20).offset(x: 15, y: 188)
            chordsRow().offset(x: 15, y: 215)
            if isChordPanelExpanded {
                chordPickerPanel
                    .offset(x: 15, y: 260)
                    .zIndex(3)
            }

            Text("Note").labelStyleBebas(20).offset(x: 15, y: 271)
            riffNoteField.offset(x: 15, y: 298)

            Button(action: saveRiff) {
                HStack(spacing: 8) {
                    Image("save_svgrepo.com")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text("SAVE RIFF")
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundStyle(.white)
                .frame(width: 340, height: 50)
                .background(Color(hex: canSaveRiff ? "6A46F3" : "3D3D3D"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(canSaveRiff ? Color(hex: "8869FF") : Color(hex: "2C2A2A"), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.soundPlain)
            .disabled(!canSaveRiff)
            .opacity(canSaveRiff ? 1 : 0.55)
            .offset(x: 15, y: 390)

            if isKeyPanelExpanded {
                keyPickerPanel
                    .offset(x: 15, y: 176)
                    .zIndex(4)
            }
        }
    }

    private var canSaveRiff: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var riffNameField: some View {
        ZStack(alignment: .leading) {
            smallFieldBackground(corner: 10)
                .frame(width: 340, height: 40)
            if title.isEmpty {
                Text("Riff Name")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "6A46F3").opacity(0.5))
                    .padding(.horizontal, 11)
                    .allowsHitTesting(false)
            }
            TextField("", text: $title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "6A46F3"))
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .keyboardType(.asciiCapable)
                .submitLabel(.done)
                .focused($focusedField, equals: .title)
                .padding(.horizontal, 11)
                .frame(width: 340, height: 40, alignment: .leading)
                .onSubmit {
                    focusedField = nil
                    dismissKeyboard()
                }
                .onChange(of: title) { newValue in
                    let next = Self.clampTitle(newValue)
                    if next != newValue { title = next }
                }
        }
        .frame(width: 340, height: 40)
    }

    private var riffNoteField: some View {
        ZStack(alignment: .topLeading) {
            smallFieldBackground(corner: 10)
                .frame(width: 340, height: 70)
            if note.isEmpty {
                Text("Add a note about this riff...")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "6A46F3").opacity(0.5))
                    .frame(width: 318, alignment: .topLeading)
                    .padding(.horizontal, 11)
                    .padding(.top, 9)
                    .allowsHitTesting(false)
            }
            TextField("", text: $note, axis: .vertical)
                .lineLimit(3...3)
                .keyboardType(.asciiCapable)
                .submitLabel(.done)
                .focused($focusedField, equals: .note)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "6A46F3"))
                .padding(.horizontal, 11)
                .padding(.top, 9)
                .frame(width: 340, height: 70, alignment: .topLeading)
                .onSubmit {
                    focusedField = nil
                    dismissKeyboard()
                }
                .onChange(of: note) { newValue in
                    if newValue.contains("\n") {
                        let replaced = Self.clampNote(newValue.replacingOccurrences(of: "\n", with: " "))
                        if replaced != note { note = replaced }
                        focusedField = nil
                        dismissKeyboard()
                        return
                    }
                    let next = Self.clampNote(newValue)
                    if next != newValue { note = next }
                }
        }
        .frame(width: 340, height: 70)
    }

    private var keyField: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isKeyPanelExpanded.toggle()
                isChordPanelExpanded = false
            }
        } label: {
            ZStack(alignment: .leading) {
                field("\(selectedKeyRoot) \(selectedKeyMode.rawValue)", width: 130, height: 40, x: 0, y: 0, opacity: 1, size: 13)
                Image(systemName: "chevron.down")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(hex: "5C45B7"))
                    .offset(x: 100, y: 3)
            }
            .frame(width: 130, height: 40, alignment: .leading)
        }
        .buttonStyle(.soundPlain)
        .offset(x: 15, y: 132)
    }

    private var keyPickerPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("MODE")
                .font(.custom("Bebas Neue", size: 16))
                .foregroundStyle(.white.opacity(0.8))

            HStack(spacing: 8) {
                keyModeChip(.major)
                keyModeChip(.minor)
            }

            Text("ROOT")
                .font(.custom("Bebas Neue", size: 16))
                .foregroundStyle(.white.opacity(0.8))
                .padding(.top, 2)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 34), spacing: 6)], spacing: 6) {
                ForEach(["A", "B", "C", "D", "E", "F", "G"], id: \.self) { root in
                    Button(root) {
                        selectedKeyRoot = root
                        withAnimation(.easeInOut(duration: 0.2)) { isKeyPanelExpanded = false }
                    }
                    .buttonStyle(.soundPlain)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(selectedKeyRoot == root ? .white : Color(hex: "6A46F3"))
                    .frame(width: 34, height: 26)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: selectedKeyRoot == root ? "6A46F3" : "0C0D0D"))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
                    )
                }
            }
        }
        .padding(10)
        .frame(width: 130)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "141414"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
        )
    }

    private func keyModeChip(_ mode: KeyMode) -> some View {
        Button(mode.rawValue.capitalized) {
            selectedKeyMode = mode
            withAnimation(.easeInOut(duration: 0.2)) { isKeyPanelExpanded = false }
        }
        .buttonStyle(.soundPlain)
        .font(.system(size: 12, weight: .semibold))
        .foregroundStyle(selectedKeyMode == mode ? .white : Color(hex: "6A46F3"))
        .frame(width: 50, height: 26)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: selectedKeyMode == mode ? "6A46F3" : "0C0D0D"))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
        )
    }

    private func myRiffsCard(riff: RiffEntry) -> some View {
        ZStack(alignment: .topLeading) {
            Button(action: { onOpenRiffDetails(riff) }) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "0C0D0D"))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
                        .frame(width: 340, height: 60)

                    Text(riff.title).font(.system(size: 15, weight: .bold)).foregroundStyle(Color(hex: "6A46F3")).offset(x: 11, y: 8)
                    Text(riff.tonalDisplay).font(.system(size: 12)).foregroundStyle(Color(hex: "5C45B7")).offset(x: 9, y: 33)
                    Text("\(riff.bpm) BPM").font(.system(size: 12)).foregroundStyle(Color(hex: "5C45B7")).offset(x: 73, y: 33)
                    Circle().fill(Color(hex: "5C45B7")).frame(width: 3, height: 3).offset(x: 63, y: 41)
                    Text("\(riff.chords.count) Chords").font(.system(size: 12)).foregroundStyle(Color(hex: "5C45B7")).offset(x: 140, y: 33)
                    Circle().fill(Color(hex: "5C45B7")).frame(width: 3, height: 3).offset(x: 130, y: 41)
                    Text(riff.createdAt, format: .dateTime.day().month().year(.twoDigits).hour().minute())
                        .font(.system(size: 13))
                        .foregroundStyle(Color.white.opacity(0.5))
                        .offset(x: 221, y: 25)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.5))
                        .offset(x: 324, y: 26)
                }
            }
            .buttonStyle(.soundPlain)
        }
        .frame(width: 340, height: 60, alignment: .topLeading)
    }

    private var myRiffsPanel: some View {
        ZStack(alignment: .topLeading) {
            cardBackground
                .frame(width: 370, height: riffsPanelHeight)
            Circle().fill(Color(hex: "6A46F3")).frame(width: 8, height: 8).offset(x: 15, y: 24)
            Text("MY RIFFS").labelStyleBebas(20).offset(x: 34, y: 18)

            VStack(spacing: 8) {
                ForEach(store.riffs) { riff in
                    myRiffsCard(riff: riff)
                }
            }
            .frame(width: 340, alignment: .leading)
            .offset(x: 15, y: 52)
        }
    }

    private var riffsListHeight: CGFloat {
        let n = CGFloat(store.riffs.count)
        guard n > 0 else { return 0 }
        return n * 60 + max(0, n - 1) * 8
    }

    private var riffsPanelHeight: CGFloat {
        52 + riffsListHeight + 14
    }

    private var contentHeight: CGFloat {
        max(844, 600 + riffsPanelHeight + 36)
    }

    private func chordsRow() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(chords) { token in
                    chordCell(token.displayTitle, xOpacity: 0.5)
                        .contextMenu {
                            Button("Duplicate") {
                                ButtonTapFeedback.play()
                                guard chords.count < 16 else { return }
                                chords.append(token)
                            }
                            Button("Delete", role: .destructive) {
                                ButtonTapFeedback.play()
                                chords.removeAll { $0.id == token.id }
                            }
                        }
                }
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isChordPanelExpanded.toggle()
                        isKeyPanelExpanded = false
                    }
                } label: {
                    if isChordPanelExpanded {
                        chordPanelCloseChip
                    } else {
                        chordCell("+", xOpacity: 1.0, dashed: true)
                    }
                }
                .buttonStyle(.soundPlain)
            }
            .frame(height: 40)
            .padding(.trailing, 8)
        }
        .frame(width: 340, alignment: .leading)
        .clipped()
    }

    private var chordPickerPanel: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 8) {
                chordCategory(title: "POWER CHORDS", chords: ChordLibrary.power)
                chordCategory(title: "OPEN / BARRE", chords: ChordLibrary.openBarre)
                chordCategory(title: "EXTENDED", chords: ChordLibrary.extended)
                tagCategory
            }
            .padding(10)
        }
        .frame(width: 340, height: 122)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "141414"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
        )
    }

    private func chordCategory(title: String, chords: [String]) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.custom("Bebas Neue", size: 14))
                .foregroundStyle(.white.opacity(0.8))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(chords, id: \.self) { chord in
                        pickerChip(chord) { appendChord(chord: chord, modifier: nil) }
                    }
                }
            }
        }
    }

    private var tagCategory: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("TAGS")
                .font(.custom("Bebas Neue", size: 14))
                .foregroundStyle(.white.opacity(0.8))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(ChordModifier.allCases, id: \.self) { modifier in
                        pickerChip("[\(modifier.rawValue)]") {
                            appendChord(chord: "E5", modifier: modifier)
                        }
                    }
                }
            }
        }
    }

    private func pickerChip(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title) {
            action()
            if chords.count >= 16 {
                withAnimation(.easeInOut(duration: 0.2)) { isChordPanelExpanded = false }
            }
        }
        .buttonStyle(.soundPlain)
        .font(.system(size: 11, weight: .semibold))
        .foregroundStyle(Color(hex: "6A46F3"))
        .padding(.horizontal, 8)
        .frame(height: 24)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "0C0D0D"))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
        )
    }

    private var chordPanelCloseChip: some View {
        Image(systemName: "xmark")
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(Color(hex: "FF0000"))
            .frame(width: 44, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "0C0D0D"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "FFFFFF"), style: StrokeStyle(lineWidth: 1, dash: [4]))
                    )
            )
    }

    private func chordCell(_ title: String, xOpacity: Double, dashed: Bool = false) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(title == "+" ? .white : Color(hex: "6A46F3"))
            .frame(width: 44, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "0C0D0D").opacity(xOpacity))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: dashed ? "FFFFFF" : "2C2A2A"), style: StrokeStyle(lineWidth: 1, dash: dashed ? [4] : []))
                    )
            )
    }

    private func tempoBlock() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TEMPO").labelStyleBebas(20)
            Text("\(bpm) BPM")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "6A46F3"))
                .offset(y: -2)
            ZStack(alignment: .leading) {
                Capsule().fill(Color(hex: "251B4D")).frame(width: 110, height: 4)
                Capsule().fill(Color(hex: "5C45B7")).frame(width: tempoFillWidth, height: 4)
                Circle()
                    .fill(.white)
                    .frame(width: 12, height: 12)
                    .overlay(Circle().stroke(Color(hex: "6A46F3"), lineWidth: 3))
                    .offset(x: max(0, tempoFillWidth - 10))
            }
            .offset(y: -2)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        bpm = bpm(from: value.location.x)
                    }
            )
            HStack {
                Text("60")
                Spacer()
                Text("220")
            }
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(Color(hex: "5C45B7"))
            .frame(width: 110)
            .offset(y: -2)
        }
    }

    private var tempoFillWidth: CGFloat {
        let progress = CGFloat(max(60, min(220, bpm)) - 60) / CGFloat(160)
        return 20 + progress * 90
    }

    private func bpm(from x: CGFloat) -> Int {
        let clampedX = max(0, min(110, x))
        let progress = clampedX / 110
        let value = 60 + Int(round(progress * 160))
        return max(60, min(220, value))
    }

    private func field(_ text: String, width: CGFloat, height: CGFloat, x: CGFloat, y: CGFloat, opacity: Double, size: CGFloat) -> some View {
        Text(text)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(Color(hex: "6A46F3").opacity(opacity))
            .padding(.horizontal, 11)
            .frame(width: width, height: height, alignment: .leading)
            .background(smallFieldBackground(corner: 10))
            .offset(x: x, y: y)
    }

    private func smallFieldBackground(corner: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: corner)
            .fill(Color(hex: "0C0D0D"))
            .overlay(RoundedRectangle(cornerRadius: corner).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color(hex: "141414"))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color(hex: "2C2A2A"), lineWidth: 1)
            )
    }

    private func appendChord(chord: String, modifier: ChordModifier?) {
        guard chords.count < 16 else { return }
        chords.append(ChordToken(chord: chord, modifier: modifier))
    }

    private func saveRiff() {
        guard canSaveRiff else { return }
        let trimmedTitle = Self.clampTitle(title.trimmingCharacters(in: .whitespacesAndNewlines))
        let trimmedNote = Self.clampNote(note.trimmingCharacters(in: .whitespacesAndNewlines))
        guard !trimmedTitle.isEmpty else { return }
        if let editingRiff {
            let updated = RiffEntry(
                id: editingRiff.id,
                title: trimmedTitle,
                keyRoot: selectedKeyRoot,
                keyMode: selectedKeyMode,
                bpm: max(60, min(220, bpm)),
                note: trimmedNote,
                chords: chords,
                createdAt: editingRiff.createdAt
            )
            store.updateRiff(updated)
            onFinishEditing?(updated)
            return
        }

        let riff = RiffEntry(
            title: trimmedTitle,
            keyRoot: selectedKeyRoot,
            keyMode: selectedKeyMode,
            bpm: max(60, min(220, bpm)),
            note: trimmedNote,
            chords: chords
        )
        store.addRiff(riff)
        title = ""
        selectedKeyRoot = "E"
        selectedKeyMode = .minor
        bpm = 120
        note = ""
        chords = []
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

private extension String {
    func englishSanitized() -> String {
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .,!?;:'\"()[]{}+-=_/@#&*%\n")
        return unicodeScalars.filter { allowed.contains($0) }.map(String.init).joined()
    }
}

private extension Text {
    func labelStyleBebas(_ size: CGFloat) -> some View {
        self
            .font(.custom("Bebas Neue", size: size))
            .foregroundStyle(.white)
    }
}

private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    CreateRiffFirstStateView()
}

