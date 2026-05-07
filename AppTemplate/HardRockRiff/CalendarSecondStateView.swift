import SwiftUI

struct CalendarSecondStateView: View {
    let onBackToHome: () -> Void
    @EnvironmentObject private var store: AppDataStore

    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2
        return cal
    }()

    init(onBackToHome: @escaping () -> Void = {}) {
        self.onBackToHome = onBackToHome
    }

    var body: some View {
        Group {
            if hasEntriesOnSelectedDay {
                CalendarFirstStateView(onBackToHome: onBackToHome, eventCardReservedHeight: detailStackHeight) {
                    dayDetailStack
                        .frame(width: 365, alignment: .leading)
                }
                .environmentObject(store)
            } else {
                CalendarFirstStateView(onBackToHome: onBackToHome)
                    .environmentObject(store)
            }
        }
    }

    private var hasEntriesOnSelectedDay: Bool {
        !(moodsOnSelectedDay.isEmpty && riffsOnSelectedDay.isEmpty)
    }

    private var moodsOnSelectedDay: [MoodEntry] {
        store.moods
            .filter { calendar.isDate($0.createdAt, inSameDayAs: store.selectedDate) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    private var riffsOnSelectedDay: [RiffEntry] {
        store.riffs
            .filter { calendar.isDate($0.createdAt, inSameDayAs: store.selectedDate) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    private var detailStackHeight: CGFloat {
        let n = moodsOnSelectedDay.count + riffsOnSelectedDay.count
        return CGFloat(n) * rowHeight + CGFloat(max(0, n - 1)) * rowSpacing
    }

    private let rowHeight: CGFloat = 70
    private let rowSpacing: CGFloat = 8

    private var dayDetailStack: some View {
        VStack(spacing: rowSpacing) {
            ForEach(moodsOnSelectedDay) { mood in
                moodDetailCard(mood)
            }
            ForEach(riffsOnSelectedDay) { riff in
                riffDetailCard(riff)
            }
        }
    }

    private func moodDetailCard(_ mood: MoodEntry) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "0C0D0D"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
                .frame(width: 365, height: rowHeight)

            Image(icon(for: mood.sound))
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(color(for: mood.sound))
                .offset(x: 14, y: 14)

            Text(title(for: mood.sound))
                .font(.custom("Bebas Neue", size: 20))
                .foregroundStyle(color(for: mood.sound))
                .offset(x: 48, y: 14)

            Text(mood.text)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color(hex: "6A46F3"))
                .lineLimit(2)
                .frame(width: 230, alignment: .leading)
                .offset(x: 14, y: 40)

            Text(entryDateText(mood.createdAt))
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.white.opacity(0.5))
                .frame(width: 98, alignment: .trailing)
                .offset(x: 255, y: 26)
        }
        .frame(width: 365, height: rowHeight)
    }

    private func riffDetailCard(_ riff: RiffEntry) -> some View {
        let accent = Color(hex: "22C55E")
        return ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "0C0D0D"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
                .frame(width: 365, height: rowHeight)

            Image("Group-4")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(accent)
                .offset(x: 14, y: 14)

            Text("RIFF RECORDED")
                .font(.custom("Bebas Neue", size: 20))
                .foregroundStyle(accent)
                .offset(x: 48, y: 14)

            Text(riff.title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color(hex: "6A46F3"))
                .lineLimit(2)
                .frame(width: 230, alignment: .leading)
                .offset(x: 14, y: 40)

            Text(entryDateText(riff.createdAt))
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.white.opacity(0.5))
                .frame(width: 98, alignment: .trailing)
                .offset(x: 255, y: 26)
        }
        .frame(width: 365, height: rowHeight)
    }

    private func title(for sound: MoodSound) -> String {
        switch sound {
        case .distortion: return "DISTORTION"
        case .cleanTone: return "CLEAN TONE"
        case .breakdown: return "BREAKDOWN"
        }
    }

    private func icon(for sound: MoodSound) -> String {
        switch sound {
        case .distortion: return "Vector-7"
        case .cleanTone: return "Group-3"
        case .breakdown: return "svgviewer-output (8) 1"
        }
    }

    private func color(for sound: MoodSound) -> Color {
        switch sound {
        case .distortion: return Color(hex: "FF0000")
        case .cleanTone: return Color(hex: "3967D2")
        case .breakdown: return Color(hex: "23252B")
        }
    }

    private func entryDateText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM.yy, H:mm"
        return formatter.string(from: date)
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
