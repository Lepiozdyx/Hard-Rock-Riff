import SwiftUI
import UIKit

private enum MoodTextLimit {
    static let maxCount = 200
}

struct MoodTrackerThirdStateView: View {
    let onOpenMoodRecord: (Date) -> Void
    let onBackToHome: () -> Void
    @EnvironmentObject private var store: AppDataStore
    @State private var selectedSound: MoodSound? = nil
    @State private var text: String = ""
    @FocusState private var isTextFocused: Bool

    init(
        onOpenMoodRecord: @escaping (Date) -> Void = { _ in },
        onBackToHome: @escaping () -> Void = {}
    ) {
        self.onOpenMoodRecord = onOpenMoodRecord
        self.onBackToHome = onBackToHome
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
                        Image("image 2111")
                            .resizable()
                            .frame(width: 196, height: 42)
                            .offset(x: 179, y: 66)

                        Image("image 2110")
                            .resizable()
                            .frame(width: 205, height: 16)
                            .offset(x: 166, y: 111)

                        Text("What's Your Sound Today?")
                            .section()
                            .offset(x: 14, y: 140)

                        toneCards
                            .offset(x: 11, y: 165)

                        Text("How are you feeling?")
                            .section()
                            .offset(x: 10, y: 297)

                        feelingCard
                            .offset(x: 13, y: 322)

                        Text("SOUND VISUALIZATION")
                            .section()
                            .offset(x: 13, y: 454)

                        visualizationCard
                            .offset(x: 13, y: 479)

                        Button(action: { ButtonTapFeedback.perform(saveMood) }) {
                            HStack(spacing: 8) {
                                Image("save_svgrepo.com")
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                Text("SAVE MOOD")
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .foregroundStyle(.white)
                            .frame(width: 340, height: 50)
                            .background(Color(hex: "6A46F3"))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "8869FF"), lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(!canSave)
                        .opacity(canSave ? 1 : 0.7)
                        .buttonStyle(.soundPlain)
                        .offset(x: 22, y: 611)

                        if store.moods.isEmpty {
                            Image("Group 10-3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 147, height: 70)
                                .opacity(0.75)
                                .offset(x: 122, y: 670)
                        } else {
                            Text("MOOD HISTORY")
                                .section()
                                .offset(x: 13, y: 677)

                            moodHistoryList
                                .offset(x: 13, y: 705)
                        }

                        Button(action: { ButtonTapFeedback.perform(onBackToHome) }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "0C0D0D"))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color(hex: "5C45B7"))
                            }
                            .frame(width: 44, height: 40)
                        }
                        .buttonStyle(.soundPlain)
                        .offset(x: 10, y: 68)
                    }
                    .frame(width: 390, height: contentHeight, alignment: .topLeading)
                    .padding(.bottom, 120)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)

           
                LinearGradient(
                    colors: [Color.clear, Color(hex: "070707")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: proxy.size.width, height: 130)
                .offset(y: proxy.size.height - 130)
                .allowsHitTesting(false)
            }
        }
        .clipped()
    }

    private var toneCards: some View {
        HStack(spacing: 10) {
            toneCard(sound: .distortion, title: "Distortion", icon: "Vector-7", active: selectedSound == .distortion, iconW: 42, iconH: 42, iconX: 37, iconY: 20)
            toneCard(sound: .cleanTone, title: "CLEAN TONE", icon: "Group-3", active: selectedSound == .cleanTone, iconW: 58, iconH: 58, iconX: 29, iconY: 11)
            toneCard(sound: .breakdown, title: "BREAKDOWN", icon: "svgviewer-output (8) 1", active: selectedSound == .breakdown, iconW: 60, iconH: 60, iconX: 28, iconY: 10)
        }
    }

    private func toneCard(sound: MoodSound, title: String, icon: String, active: Bool, iconW: CGFloat, iconH: CGFloat, iconX: CGFloat, iconY: CGFloat) -> some View {
        let accent = toneColor(sound)
        return ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "141414"))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(active ? accent : Color(hex: "2C2A2A"), lineWidth: 1)
                )

            Image(icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: iconW, height: iconH)
                .foregroundStyle(active ? accent : .white)
                .offset(x: iconX, y: iconY)

            Text(title)
                .font(.custom("Bebas Neue", size: 20))
                .foregroundStyle(active ? accent : .white)
                .frame(maxWidth: .infinity)
                .offset(y: 80)
        }
        .frame(width: 116, height: 116)
        .onTapGestureWithButtonFeedback { selectedSound = sound }
    }

    private var feelingCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "141414"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("Enter text")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "6A46F3").opacity(0.5))
                        .allowsHitTesting(false)
                }
                TextField("", text: $text, axis: .vertical)
                    .lineLimit(3...3)
                    .keyboardType(.asciiCapable)
                    .submitLabel(.done)
                    .focused($isTextFocused)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "6A46F3"))
                    .frame(width: 318, height: 78, alignment: .topLeading)
                    .onSubmit {
                        isTextFocused = false
                        dismissKeyboard()
                    }
                    .onChange(of: text) { newValue in
                        if newValue.contains("\n") {
                            let replaced = Self.clampMoodText(newValue.replacingOccurrences(of: "\n", with: " "))
                            if replaced != text { text = replaced }
                            isTextFocused = false
                            dismissKeyboard()
                            return
                        }
                        let next = Self.clampMoodText(newValue)
                        if next != newValue { text = next }
                    }
            }
            .frame(width: 318, height: 78, alignment: .topLeading)
            .offset(x: 13, y: 9)

            Text("\(text.count) / 200")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.white)
                .offset(x: 317, y: 88)
        }
        .frame(width: 366, height: 116)
    }

    private var visualizationCard: some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "141414"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
            if let selectedSound {
                Image("image 2107-5")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 345, height: 70)
                    .foregroundStyle(toneColor(selectedSound))
            } else {
                Image("image 2107-5")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 345, height: 70)
            }
        }
        .frame(width: 366, height: 116)
    }

    private var canSave: Bool {
        selectedSound != nil && !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && text.count <= 200
    }

    private func saveMood() {
        guard canSave, let selectedSound else { return }
        store.addMood(MoodEntry(sound: selectedSound, text: Self.clampMoodText(text.trimmingCharacters(in: .whitespacesAndNewlines))))
        text = ""
        self.selectedSound = nil
    }

    private var moodHistoryList: some View {
        VStack(spacing: 8) {
            ForEach(store.moods) { mood in
                moodHistoryCard(mood)
            }
        }
    }

    private func moodHistoryCard(_ mood: MoodEntry) -> some View {
        return Button {
            ButtonTapFeedback.play()
            onOpenMoodRecord(mood.createdAt)
        } label: {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "0C0D0D"))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))

                Image(toneIcon(mood.sound))
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .foregroundStyle(toneColor(mood.sound))
                    .offset(x: 11, y: 17)

                Text(mood.text)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "6A46F3"))
                    .frame(width: 170, alignment: .leading)
                    .lineLimit(2)
                    .offset(x: 62, y: 14)

                Text(moodDateText(mood.createdAt))
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.white.opacity(0.5))
                    .lineLimit(1)
                    .minimumScaleFactor(0.95)
                    .frame(width: 92, height: 22, alignment: .center)
                    .offset(x: 246, y: 19)

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.white.opacity(0.5))
                    .frame(width: 16, height: 16)
                    .offset(x: 341, y: 22)
            }
            .frame(width: 365, height: 60)
        }
        .buttonStyle(.soundPlain)
    }

    private static func clampMoodText(_ raw: String) -> String {
        String(raw.englishSanitized().prefix(MoodTextLimit.maxCount))
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func moodDateText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM.yy, H:mm"
        return formatter.string(from: date)
    }

    private var contentHeight: CGFloat {
        if store.moods.isEmpty { return 844 }
        let listBottom = 705 + CGFloat(store.moods.count) * 68
        return max(844, listBottom + 30)
    }

    private func toneColor(_ sound: MoodSound) -> Color {
        switch sound {
        case .distortion:
            return Color(hex: "FF0000")
        case .cleanTone:
            return Color(hex: "3967D2")
        case .breakdown:
            return Color(hex: "23252B")
        }
    }

    private func toneIcon(_ sound: MoodSound) -> String {
        switch sound {
        case .distortion:
            return "Vector-7"
        case .cleanTone:
            return "Group-3"
        case .breakdown:
            return "svgviewer-output (8) 1"
        }
    }
}

private extension String {
    func englishSanitized() -> String {
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .,!?;:'\"()[]{}+-=_/@#&*%\n")
        return unicodeScalars.filter { allowed.contains($0) }.map(String.init).joined()
    }
}

private extension Text {
    func section() -> some View {
        self
            .font(.custom("Bebas Neue", size: 20))
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
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

