import SwiftUI

struct MoodTrackerFirstStateView: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var selectedSound: MoodSound? = nil
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

                        Button {} label: {
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
                        .buttonStyle(.soundPlain)
                        .offset(x: 22, y: 611)

                        Text("MOOD HISTORY")
                            .section()
                            .offset(x: 13, y: 677)

                        moodHistoryCard
                            .offset(x: 13, y: 705)

                        Button {} label: {
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
                    .frame(width: 390, height: 844, alignment: .topLeading)
                    .padding(.bottom, 120)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .clipped()
    }

    private var toneCards: some View {
        let current = selectedSound ?? store.moods.first?.sound
        return HStack(spacing: 10) {
            toneCard(title: "Distortion", icon: "Vector-7", active: current == .distortion, iconW: 42, iconH: 42, iconX: 37, iconY: 20)
            toneCard(title: "CLEAN TONE", icon: "Group-3", active: current == .cleanTone, iconW: 58, iconH: 58, iconX: 29, iconY: 11)
            toneCard(title: "BREAKDOWN", icon: "svgviewer-output (8) 1", active: current == .breakdown, iconW: 60, iconH: 60, iconX: 28, iconY: 10)
        }
    }

    private func toneCard(title: String, icon: String, active: Bool, iconW: CGFloat, iconH: CGFloat, iconX: CGFloat, iconY: CGFloat) -> some View {
        let sound = soundForTitle(title)
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

            Text(latestMoodText)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "6A46F3"))
                .frame(width: 318, alignment: .leading)
                .lineLimit(2)
                .offset(x: 13, y: 9)

            Text("\(latestMoodText.count) / 200")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.white)
                .offset(x: 317, y: 88)
        }
        .frame(width: 366, height: 116)
    }

    private var visualizationCard: some View {
        let active = selectedSound ?? store.moods.first?.sound ?? .distortion
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "141414"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
            Image("image 2107-5")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 345, height: 70)
                .foregroundStyle(toneColor(active))
        }
        .frame(width: 366, height: 116)
    }

    private var moodHistoryCard: some View {
        let sound = store.moods.first?.sound ?? .distortion
        return ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "0C0D0D"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))

            Image(iconName(for: sound))
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 26, height: 26)
                .foregroundStyle(toneColor(sound))
                .offset(x: 11, y: 17)

            Text(latestMoodText)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "6A46F3"))
                .frame(width: 198, alignment: .leading)
                .lineLimit(2)
                .offset(x: 62, y: 14)

            Text(latestMoodDate)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.white.opacity(0.5))
                .offset(x: 260, y: 19)

            Image(systemName: "chevron.right")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.5))
                .offset(x: 351, y: 21)
        }
        .frame(width: 365, height: 60)
    }

    private var latestMoodText: String {
        store.moods.first?.text ?? "Today - Distortion: project is fire, but I am low on energy."
    }

    private var latestMoodDate: String {
        guard let date = store.moods.first?.createdAt else { return "29.04.26, 9:30" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM.yy, H:mm"
        return formatter.string(from: date)
    }

    private func soundForTitle(_ title: String) -> MoodSound {
        switch title {
        case "Distortion":
            return .distortion
        case "CLEAN TONE":
            return .cleanTone
        default:
            return .breakdown
        }
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

    private func iconName(for sound: MoodSound) -> String {
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

