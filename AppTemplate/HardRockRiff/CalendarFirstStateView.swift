import SwiftUI

struct CalendarFirstStateView<Accessory: View>: View {
    let onBackToHome: () -> Void
  
    let eventCardReservedHeight: CGFloat
    @ViewBuilder private let accessory: () -> Accessory
    @EnvironmentObject private var store: AppDataStore
    private let columns = Array(repeating: GridItem(.fixed(43.2), spacing: 7.2), count: 7)
    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2
        return cal
    }()

    init(
        onBackToHome: @escaping () -> Void = {},
        eventCardReservedHeight: CGFloat = 0,
        @ViewBuilder accessory: @escaping () -> Accessory
    ) {
        self.onBackToHome = onBackToHome
        self.eventCardReservedHeight = eventCardReservedHeight
        self.accessory = accessory
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
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)
                        ZStack(alignment: .topLeading) {
                            Image("image 2107-3")
                                .resizable()
                                .frame(width: 149, height: 40)
                                .offset(x: 222, y: 64)

                            Image("image 2108-2")
                                .resizable()
                                .frame(width: 90, height: 15)
                                .offset(x: 281, y: 112)

                            Button(action: { ButtonTapFeedback.perform(onBackToHome) }) {
                                navBackButton
                            }
                            .buttonStyle(.soundPlain)
                            .offset(x: 10, y: 68)

                            todayButton
                                .offset(x: 64, y: 68)

                            datePickerCard
                                .offset(x: 10, y: 149)

                            legend
                                .offset(x: 31, y: legendTop)

                            if !hasEntriesOnSelectedDay {
                                Image("Group 10")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 212, height: 140)
                                    .opacity(0.5)
                                    .offset(x: 90, y: illustrationTop)
                            }

                            accessory()
                                .offset(x: accessoryOffsetX, y: accessoryTop)
                        }
                        .frame(width: 390, height: scrollContentHeight, alignment: .topLeading)
                        Spacer(minLength: 0)
                    }
                    .padding(.bottom, 130)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .ignoresSafeArea()
    }

    
    private var scrollContentHeight: CGFloat {
        let accessoryBottom = accessoryTop + eventCardReservedHeight
        if hasEntriesOnSelectedDay {
            return max(844, accessoryBottom + 24)
        }
        let illustrationBottom = illustrationTop + 140
        let bottomEdge = max(illustrationBottom, accessoryBottom)
        return max(844, bottomEdge + 24)
    }

    private var hasEntriesOnSelectedDay: Bool {
        let date = store.selectedDate
        let mood = store.moods.contains { calendar.isDate($0.createdAt, inSameDayAs: date) }
        let riff = store.riffs.contains { calendar.isDate($0.createdAt, inSameDayAs: date) }
        return mood || riff
    }

   
    private let dateCardHeight: CGFloat = 428
    private var legendTop: CGFloat { 149 + dateCardHeight + 14 }
  
    private var accessoryTop: CGFloat { legendTop + 22 }
    private var illustrationTop: CGFloat {
        if eventCardReservedHeight > 0 {
            accessoryTop + eventCardReservedHeight + 14
        } else {
            legendTop + 28
        }
    }
    private var accessoryOffsetX: CGFloat { 13 }

    private var navBackButton: some View {
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

    private var todayButton: some View {
        Button {
            ButtonTapFeedback.play()
            store.selectedDate = .now
            store.selectedMonth = .now
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "0C0D0D"))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
                HStack(spacing: 6) {
                    Image("svgviewer-output (9) 1")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(hex: "6A46F3"))
                    Text("TODAY")
                        .font(.custom("Bebas Neue", size: 20))
                        .foregroundStyle(Color(hex: "6A46F3"))
                }
                .offset(x: -2, y: -1)
            }
            .frame(width: 100, height: 40)
        }
        .buttonStyle(.soundPlain)
    }

    private var datePickerCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 21)
                .fill(Color(hex: "141414"))
                .overlay(RoundedRectangle(cornerRadius: 21).stroke(Color(hex: "291F51"), lineWidth: 0.9))
                .frame(width: 370, height: dateCardHeight)
            HStack(spacing: 7.2) {
                Button("‹") {
                    ButtonTapFeedback.play()
                    shiftMonth(by: -1)
                }
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Color(hex: "6A46F3").opacity(0.5))
                    .frame(width: 43.2, height: 43.2)
                    .buttonStyle(.soundPlain)
                Text(monthTitle)
                    .font(.custom("Bebas Neue", size: 25))
                    .foregroundStyle(.white)
                    .frame(width: 244.8, height: 43.4)
                Button("›") {
                    ButtonTapFeedback.play()
                    shiftMonth(by: 1)
                }
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Color(hex: "6A46F3"))
                    .frame(width: 43.2, height: 43.2)
                    .buttonStyle(.soundPlain)
            }
            .offset(x: 12.2, y: 8)
            VStack(spacing: 7) {
                LazyVGrid(columns: columns, spacing: 7.2) {
                    ForEach(["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"], id: \.self) { day in
                        Text(day)
                            .font(.custom("Bebas Neue", size: 18))
                            .foregroundStyle(Color(hex: "8869FF"))
                            .frame(width: 43.2, height: 43.4)
                            .background(RoundedRectangle(cornerRadius: 7.2).fill(Color(hex: "140F28")))
                    }
                }
                .frame(width: 345.6, height: 43.4)
                LazyVGrid(columns: columns, spacing: 7.2) {
                    ForEach(monthGridDays, id: \.id) { cell in
                        dayCell(cell)
                    }
                }
                .frame(width: 345.6, alignment: .top)
            }
            .frame(width: 345.6, alignment: .topLeading)
            .offset(x: 13, y: 59)
        }
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 35)
                .onEnded { value in
                    let dx = value.translation.width
                    let dy = value.translation.height
                    guard abs(dx) > abs(dy), abs(dx) > 45 else { return }
                    shiftMonth(by: dx < 0 ? 1 : -1)
                }
        )
    }

    private var legend: some View {
        HStack(spacing: 18) {
            legendItem(color: Color(hex: "FF0000"), title: "DISTORTION")
            legendItem(color: Color(hex: "3967D2"), title: "CLEAN TONE")
            legendItem(color: Color(hex: "23252B"), title: "BREAKDOWN", breakdownStroke: Color(hex: "8869FF"))
            legendItem(color: Color(hex: "22C55E"), title: "RIFF RECORDED")
        }
    }

    private func legendItem(color: Color, title: String, breakdownStroke: Color? = nil) -> some View {
        HStack(spacing: 4) {
            ZStack {
                Circle().fill(color).frame(width: 8, height: 8)
                if let breakdownStroke {
                    Circle().stroke(breakdownStroke, lineWidth: 1).frame(width: 8, height: 8)
                }
            }
            Text(title)
                .font(.custom("Bebas Neue", size: 15))
                .foregroundStyle(.white)
        }
    }

    private var monthGridDays: [CalendarCell] {
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: store.selectedMonth)) ?? store.selectedMonth
        let range = calendar.range(of: .day, in: .month, for: monthStart) ?? 1..<32
        let daysInMonth = range.count
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let leading = (firstWeekday + 5) % 7
        return (0..<42).compactMap { idx in
            let dayOffset = idx - leading
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: monthStart) else { return nil }
            return CalendarCell(id: "\(idx)-\(date.timeIntervalSince1970)", date: date, dayText: "\(calendar.component(.day, from: date))", inCurrentMonth: dayOffset >= 0 && dayOffset < daysInMonth)
        }
    }

    private func markerKinds(for date: Date) -> [SessionCalendarMarkerKind] {
        let moodsThisDay = store.moods.filter { calendar.isDate($0.createdAt, inSameDayAs: date) }
        let sounds = Set(moodsThisDay.map(\.sound))
        var kinds: [SessionCalendarMarkerKind] = []
        if sounds.contains(.distortion) { kinds.append(.distortion) }
        if sounds.contains(.cleanTone) { kinds.append(.cleanTone) }
        if sounds.contains(.breakdown) { kinds.append(.breakdown) }
        if store.riffs.contains(where: { calendar.isDate($0.createdAt, inSameDayAs: date) }) {
            kinds.append(.riff)
        }
        return kinds
    }

    private func dayCell(_ cell: CalendarCell) -> some View {
        let selected = calendar.isDate(cell.date, inSameDayAs: store.selectedDate)
        let markers = markerKinds(for: cell.date)
        let dotSize: CGFloat = markers.count > 2 ? 5 : 6
        return Button {
            ButtonTapFeedback.play()
            store.selectedDate = cell.date
            store.selectedMonth = cell.date
        } label: {
            ZStack(alignment: .bottom) {
                Text(cell.dayText)
                    .font(.custom("Bebas Neue", size: 18))
                    .foregroundStyle(Color(hex: cell.inCurrentMonth ? "FFFFFF" : "8869FF"))
                    .frame(width: 43.2, height: 43.4)
                    .background(
                        RoundedRectangle(cornerRadius: 7.2)
                            .fill(Color(hex: selected ? "6A46F3" : (cell.inCurrentMonth ? "291F51" : "140F28")))
                    )
                if !markers.isEmpty {
                    HStack(spacing: 2) {
                        ForEach(markers, id: \.self) { kind in
                            sessionMarkerDot(kind, diameter: dotSize)
                        }
                    }
                    .frame(width: 43.2)
                    .offset(y: -3)
                }
            }
        }
        .buttonStyle(.soundPlain)
    }

    @ViewBuilder
    private func sessionMarkerDot(_ kind: SessionCalendarMarkerKind, diameter: CGFloat) -> some View {
        switch kind {
        case .distortion:
            Circle().fill(Color(hex: "FF0000")).frame(width: diameter, height: diameter)
        case .cleanTone:
            Circle().fill(Color(hex: "3967D2")).frame(width: diameter, height: diameter)
        case .breakdown:
            Circle()
                .fill(Color(hex: "23252B"))
                .overlay(Circle().stroke(Color(hex: "8869FF"), lineWidth: 1))
                .frame(width: diameter, height: diameter)
        case .riff:
            Circle().fill(Color(hex: "22C55E")).frame(width: diameter, height: diameter)
        }
    }

    private func shiftMonth(by value: Int) {
        guard let next = calendar.date(byAdding: .month, value: value, to: store.selectedMonth) else { return }
        store.selectedMonth = next
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: store.selectedMonth).lowercased()
    }
}

extension CalendarFirstStateView where Accessory == EmptyView {
    init(onBackToHome: @escaping () -> Void = {}) {
        self.init(onBackToHome: onBackToHome, eventCardReservedHeight: 0) { EmptyView() }
    }
}

private enum SessionCalendarMarkerKind: Hashable {
    case distortion
    case cleanTone
    case breakdown
    case riff
}

private struct CalendarCell {
    let id: String
    let date: Date
    let dayText: String
    let inCurrentMonth: Bool
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
