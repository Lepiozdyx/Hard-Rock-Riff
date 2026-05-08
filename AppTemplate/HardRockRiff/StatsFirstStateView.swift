import SwiftUI

struct StatsFirstStateView: View {
    let onBackToHome: () -> Void
    @EnvironmentObject private var store: AppDataStore

    private let calendar = Calendar.current
    private let barXs: [CGFloat] = [46, 120, 204, 290]
    private let chartBaselineY: CGFloat = 146
    private let chartTopY: CGFloat = 61
    private let minBarHeight: CGFloat = 5
    private let maxBarHeight: CGFloat = 67

    init(onBackToHome: @escaping () -> Void = {}) {
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

                ZStack(alignment: .topLeading) {
                    Image("image 2109-2")
                        .resizable()
                        .frame(width: 273, height: 38)
                        .offset(x: 102, y: 74)

                    Image("image 2107-6")
                        .resizable()
                        .frame(width: 148, height: 15)
                        .offset(x: 222, y: 122)

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

                    monthPicker
                        .offset(x: 10, y: 150)

                    totalRiffsCard
                        .offset(x: 10, y: 222)

                    mostCommonKeyCard
                        .offset(x: 200, y: 222)

                    averageTempoCard
                        .offset(x: 10, y: 316)

                    dominantSoundCard
                        .offset(x: 200, y: 316)

                    weeklyActivityCard
                        .offset(x: 12, y: 410)

                    moodDistributionCard
                        .offset(x: 12, y: 602)
                }
                .frame(width: 390, height: 844, alignment: .topLeading)
                .offset(x: max(0, (proxy.size.width - 390) / 2), y: max(0, (proxy.size.height - 844) / 2) - 16)
                .clipped()
            }
        }
        .ignoresSafeArea()
    }

    private var riffsInMonth: [RiffEntry] {
        store.riffs(in: store.selectedMonth)
    }

    private var moodsInMonth: [MoodEntry] {
        store.moods(in: store.selectedMonth)
    }

    private var monthPicker: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 21)
                .fill(Color(hex: "141414"))
                .overlay(RoundedRectangle(cornerRadius: 21).stroke(Color(hex: "291F51"), lineWidth: 0.9))
                .frame(width: 370, height: 59)

            HStack(spacing: 7.2) {
                Button {
                    ButtonTapFeedback.play()
                    shiftMonth(by: -1)
                } label: {
                    Text("‹")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(Color(hex: "6A46F3").opacity(0.5))
                        .frame(width: 43.2, height: 43.2)
                }
                .buttonStyle(.soundPlain)

                Text(monthTitle)
                    .font(.custom("Bebas Neue", size: 25))
                    .foregroundStyle(.white)
                    .frame(width: 244.8, height: 43.4)

                Button {
                    ButtonTapFeedback.play()
                    shiftMonth(by: 1)
                } label: {
                    Text("›")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(Color(hex: "6A46F3"))
                        .frame(width: 43.2, height: 43.2)
                }
                .buttonStyle(.soundPlain)
            }
            .frame(width: 345.6, height: 43.4)
        }
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: store.selectedMonth).lowercased()
    }

    private func shiftMonth(by delta: Int) {
        guard let next = calendar.date(byAdding: .month, value: delta, to: store.selectedMonth) else { return }
        store.selectedMonth = next
    }

    private var totalRiffsCard: some View {
        metricCard(
            title: "TOTAL RIFF RECORDED",
            value: "\(riffsInMonth.count)",
            valueColor: Color(hex: "FF0000"),
            icon: "Group-4",
            iconSize: CGSize(width: 54, height: 54),
            iconX: 6,
            iconY: 13
        )
    }

    private var mostCommonKeyCard: some View {
        metricCard(
            title: "MOST COMMON KEY",
            value: mostCommonKeyDisplay,
            valueColor: Color(hex: "6A46F3"),
            icon: "svgviewer-output (10) 1",
            iconSize: CGSize(width: 58, height: 35),
            iconX: 8,
            iconY: 20,
            valueSize: mostCommonKeyDisplay.count > 8 ? 22 : 34
        )
    }

    private var mostCommonKeyDisplay: String {
        guard !riffsInMonth.isEmpty else { return "NONE" }
        var counts: [String: Int] = [:]
        for r in riffsInMonth {
            let label = "\(r.keyRoot) \(r.keyMode.rawValue.uppercased())"
            counts[label, default: 0] += 1
        }
        let maxCount = counts.values.max() ?? 0
        return counts.first(where: { $0.value == maxCount })?.key ?? "NONE"
    }

    private var averageTempoCard: some View {
        metricCard(
            title: "AVERAGE TEMPO",
            value: averageTempoDisplay,
            valueColor: Color(hex: "FFE100"),
            icon: "svgviewer-output (12) 1",
            iconSize: CGSize(width: 42, height: 42),
            iconX: 12,
            iconY: 20,
            valueSize: averageTempoDisplay == "NONE" ? 34 : 34
        )
    }

    private var averageTempoDisplay: String {
        guard !riffsInMonth.isEmpty else { return "NONE" }
        let sum = riffsInMonth.reduce(0) { $0 + $1.bpm }
        return "\(sum / riffsInMonth.count)"
    }

    private var dominantSoundCard: some View {
        let label = dominantSoundDisplay
        return metricCard(
            title: "DOMINANT SOUND OF THE\nMOTCH",
            value: label,
            valueColor: Color(hex: "00FF55"),
            icon: "svgviewer-output (11) 1",
            iconSize: CGSize(width: 41, height: 41),
            iconX: 12,
            iconY: 20,
            titleY: 8,
            valueSize: label == "NONE" ? 34 : (label.count > 11 ? 22 : 31)
        )
    }

    private var dominantSoundDisplay: String {
        guard !moodsInMonth.isEmpty else { return "NONE" }
        var counts: [MoodSound: Int] = [.distortion: 0, .cleanTone: 0, .breakdown: 0]
        for m in moodsInMonth {
            counts[m.sound, default: 0] += 1
        }
        let maxCount = counts.values.max() ?? 0
        guard maxCount > 0 else { return "NONE" }
        let priority: [MoodSound] = [.distortion, .cleanTone, .breakdown]
        guard let winner = priority.first(where: { counts[$0, default: 0] == maxCount }) else { return "NONE" }
        switch winner {
        case .distortion: return "DISTORTION"
        case .cleanTone: return "CLEAN TONE"
        case .breakdown: return "BREAKDOWN"
        }
    }

    private func metricCard(
        title: String,
        value: String,
        valueColor: Color,
        icon: String,
        iconSize: CGSize,
        iconX: CGFloat,
        iconY: CGFloat,
        titleY: CGFloat = 10,
        titleX: CGFloat = 54,
        textWidth: CGFloat = 116,
        valueSize: CGFloat = 34
    ) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "141414"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "6A46F3"), lineWidth: 1))
                .frame(width: 180, height: 80)

            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize.width, height: iconSize.height)
                .offset(x: iconX, y: iconY)

            Text(title)
                .font(.custom("Bebas Neue", size: 13))
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.leading)
                .lineSpacing(-1)
                .frame(width: textWidth, alignment: .leading)
                .offset(x: titleX, y: titleY)

            Text(value)
                .font(.custom("Bebas Neue", size: valueSize))
                .foregroundStyle(valueColor)
                .lineLimit(2)
                .minimumScaleFactor(0.65)
                .frame(width: textWidth, alignment: .leading)
                .offset(x: titleX, y: 34)
        }
    }

    private var weeklyActivityCard: some View {
        let buckets = weekBuckets(for: store.selectedMonth)
        let counts = buckets.map { activityCount(in: $0) }
        let maxC = max(counts.max() ?? 0, 1)
        let chartH = chartBaselineY - chartTopY

        return ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "141414"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
                .frame(width: 366, height: 180)

            Text("WEEKLY ACTIVITY")
                .font(.custom("Bebas Neue", size: 20))
                .foregroundStyle(.white)
                .offset(x: 12, y: 11)

            Text("Number of riffs and mood entries")
                .font(.system(size: 15, weight: .light))
                .foregroundStyle(.white)
                .offset(x: 34, y: 31)

            let ticks = [0, maxC / 2, maxC]
            let tickYPositions: [CGFloat] = [129, 99, 69]
            ForEach(Array(ticks.enumerated()), id: \.offset) { idx, tick in
                Text("\(tick)")
                    .font(.system(size: 15, weight: .light))
                    .foregroundStyle(.white.opacity(0.5))
                    .offset(x: tick == maxC && maxC >= 10 ? 13 : 16, y: tickYPositions[min(idx, tickYPositions.count - 1)])
            }

            RoundedRectangle(cornerRadius: 2)
                .fill(LinearGradient(colors: [Color(hex: "6A46F3"), Color(hex: "3E298D")], startPoint: .top, endPoint: .bottom))
                .frame(width: 12, height: 12)
                .offset(x: 13, y: 35)

            ForEach(Array(zip(barXs, counts).enumerated()), id: \.offset) { _, pair in
                let h = barHeight(count: pair.1, maxCount: maxC)
                RoundedRectangle(cornerRadius: 2)
                    .fill(LinearGradient(colors: [Color(hex: "6A46F3"), Color(hex: "3E298D")], startPoint: .top, endPoint: .bottom))
                    .frame(width: 40, height: h)
                    .offset(x: pair.0, y: chartBaselineY - h)
            }

            Rectangle()
                .fill(.white.opacity(0.75))
                .frame(width: 1, height: 85)
                .offset(x: 39, y: 61)
            Rectangle()
                .fill(.white.opacity(0.75))
                .frame(width: 307, height: 1)
                .offset(x: 39, y: 146)

            ForEach(Array(zip(barXs, buckets).enumerated()), id: \.offset) { _, pair in
                Text(pair.1.label)
                    .font(.system(size: 11, weight: .light))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(width: 76, alignment: .center)
                    .offset(x: pair.0 - 18, y: 149)
            }
        }
    }

    private func barHeight(count: Int, maxCount: Int) -> CGFloat {
        guard count > 0 else { return minBarHeight }
        let ratio = CGFloat(count) / CGFloat(max(maxCount, 1))
        return minBarHeight + ratio * (maxBarHeight - minBarHeight)
    }

    private struct WeekBucket {
        let startDay: Int
        let endDay: Int
        let label: String
    }

    private func weekBuckets(for month: Date) -> [WeekBucket] {
        guard let dayRange = calendar.range(of: .day, in: .month, for: month) else { return [] }
        let lastDay = dayRange.count
        let abbrev = monthAbbrev(for: month)

        func bucket(_ start: Int, _ end: Int) -> WeekBucket {
            let e = min(end, lastDay)
            let s = min(start, lastDay)
            if s > lastDay {
                return WeekBucket(startDay: s, endDay: e, label: "")
            }
            return WeekBucket(startDay: s, endDay: e, label: "\(s)-\(e) \(abbrev)")
        }

        return [
            bucket(1, 7),
            bucket(8, 15),
            bucket(16, 23),
            bucket(24, lastDay),
        ]
    }

    private func monthAbbrev(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM"
        return formatter.string(from: date).uppercased()
    }

    private func activityCount(in bucket: WeekBucket) -> Int {
        guard bucket.startDay <= bucket.endDay else { return 0 }
        func inBucket(_ d: Date) -> Bool {
            let day = calendar.component(.day, from: d)
            return day >= bucket.startDay && day <= bucket.endDay
        }
        return riffsInMonth.filter { inBucket($0.createdAt) }.count
            + moodsInMonth.filter { inBucket($0.createdAt) }.count
    }

    private var moodDistributionCard: some View {
        let d = moodsInMonth.filter { $0.sound == .distortion }.count
        let cl = moodsInMonth.filter { $0.sound == .cleanTone }.count
        let br = moodsInMonth.filter { $0.sound == .breakdown }.count
        let total = d + cl + br

        return ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "141414"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
                .frame(width: 366, height: 141)

            Text("MOOD DISTRIBUTION")
                .font(.custom("Bebas Neue", size: 20))
                .foregroundStyle(.white)
                .offset(x: 12, y: 11)

            Group {
                if total == 0 {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 90, height: 90)
                } else {
                    MoodPieChartView(distortion: d, clean: cl, breakdown: br)
                }
            }
            .frame(width: 90, height: 90)
            .offset(x: 19, y: 36)

            Circle().fill(Color(hex: "FF0000")).frame(width: 8, height: 8).offset(x: 152, y: 43)
            Circle().fill(Color(hex: "3967D2")).frame(width: 8, height: 8).offset(x: 152, y: 78)
            Circle().fill(Color(hex: "23252B")).frame(width: 8, height: 8).offset(x: 152, y: 113)

            Text("DISTORTION").font(.custom("Bebas Neue", size: 15)).foregroundStyle(.white).offset(x: 174, y: 36)
            Text("CLEAN TONE").font(.custom("Bebas Neue", size: 15)).foregroundStyle(.white).offset(x: 174, y: 71)
            Text("BREAKDOWN").font(.custom("Bebas Neue", size: 15)).foregroundStyle(.white).offset(x: 174, y: 106)

            Text("\(moodPercentage(part: d, total: total))%").font(.custom("Bebas Neue", size: 15)).foregroundStyle(Color(hex: "6A46F3")).offset(x: 299, y: 36)
            Text("\(moodPercentage(part: cl, total: total))%").font(.custom("Bebas Neue", size: 15)).foregroundStyle(Color(hex: "6A46F3")).offset(x: 299, y: 72)
            Text("\(moodPercentage(part: br, total: total))%").font(.custom("Bebas Neue", size: 15)).foregroundStyle(Color(hex: "6A46F3")).offset(x: 299, y: 107)

            Rectangle().fill(.white.opacity(0.4)).frame(width: 187, height: 1).offset(x: 152, y: 64)
            Rectangle().fill(.white.opacity(0.4)).frame(width: 187, height: 1).offset(x: 152, y: 100)
        }
    }

    private func moodPercentage(part: Int, total: Int) -> Int {
        guard total > 0 else { return 0 }
        return Int((100.0 * Double(part) / Double(total)).rounded())
    }
}

private struct MoodPieChartView: View {
    let distortion: Int
    let clean: Int
    let breakdown: Int

    private struct SliceModel: Identifiable {
        let id: Int
        let start: Angle
        let end: Angle
        let color: Color
    }

    private var slices: [SliceModel] {
        let total = distortion + clean + breakdown
        guard total > 0 else { return [] }
        let parts: [(Int, Color)] = [
            (distortion, Color(hex: "FF0000")),
            (clean, Color(hex: "3967D2")),
            (breakdown, Color(hex: "23252B")),
        ]
        var angle = Angle.degrees(-90)
        var result: [SliceModel] = []
        var nextId = 0
        for (count, color) in parts where count > 0 {
            let delta = Angle.degrees(360 * Double(count) / Double(total))
            result.append(SliceModel(id: nextId, start: angle, end: angle + delta, color: color))
            nextId += 1
            angle += delta
        }
        return result
    }

    var body: some View {
        ZStack {
            ForEach(slices) { slice in
                PieSlice(startAngle: slice.start, endAngle: slice.end)
                    .fill(slice.color)
            }
        }
    }
}

private struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
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
