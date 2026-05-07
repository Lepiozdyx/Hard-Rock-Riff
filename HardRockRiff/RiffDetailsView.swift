import SwiftUI

struct RiffDetailsView: View {
    let riff: RiffEntry
    let onBack: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    init(riff: RiffEntry, onBack: @escaping () -> Void = {}, onEdit: @escaping () -> Void = {}, onDelete: @escaping () -> Void = {}) {
        self.riff = riff
        self.onBack = onBack
        self.onEdit = onEdit
        self.onDelete = onDelete
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
                    Image("Frame 94036-2")
                        .resizable()
                        .frame(width: 473, height: 1023)
                        .offset(x: -28, y: -111)

                    LinearGradient(
                        colors: [Color.black.opacity(0.0), Color(hex: "070707")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: 390, height: 844)

                    Image("image 2108")
                        .resizable()
                        .frame(width: 163, height: 146)
                        .scaleEffect(x: -1, y: 1)
                        .offset(x: 57, y: 60)

                    Text(riff.title)
                        .font(.custom("Bebas Neue", size: 35))
                        .foregroundStyle(Color(hex: "E4DBCE"))
                        .offset(x: 240, y: 74)

                    Text(riff.tonalDisplay)
                        .font(.custom("Bebas Neue", size: 20))
                        .foregroundStyle(Color(hex: "E4DBCE"))
                        .offset(x: 250, y: 108)

                    Circle()
                        .fill(Color(hex: "E4DBCE"))
                        .frame(width: 6, height: 6)
                        .offset(x: 316, y: 115)

                    Text("\(riff.bpm) BPM")
                        .font(.custom("Bebas Neue", size: 20))
                        .foregroundStyle(Color(hex: "E4DBCE"))
                        .offset(x: 319, y: 108)

                    Text("Created \(riff.createdAt, format: .dateTime.day().month().year(.twoDigits).hour().minute())")
                        .font(.custom("Bebas Neue", size: 15))
                        .foregroundStyle(Color(hex: "E4DBCE").opacity(0.5))
                        .offset(x: 260, y: 147)

                    Button(action: onBack) {
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

                    detailsCard
                        .frame(width: 370, height: 470)
                        .offset(x: 10, y: 175)

                    HStack(spacing: 10) {
                    actionButton(title: "EDIT", assetIcon: "out", bg: Color(hex: "141414"), border: Color(hex: "2C2A2A"), action: onEdit)
                        actionButton(title: "DELETE", assetIcon: "svgviewer-output (5) 1", bg: Color(hex: "F34646"), border: Color(hex: "FF6969"), action: onDelete)
                    }
                    .offset(x: 20, y: 664)
                }
                .frame(width: 390, height: 844, alignment: .topLeading)
                .offset(x: max(0, (proxy.size.width - 390) / 2), y: max(0, (proxy.size.height - 844) / 2))
                .clipped()
            }
        }
        .clipped()
    }

    private var detailsCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "141414"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))

            field(riff.title, width: 340, height: 40, x: 15, y: 20)

            Text("KEY").section().offset(x: 15, y: 76)
            Text("BPM").section().offset(x: 155, y: 76)
            Text("TEMPO").section().offset(x: 245, y: 76)

            field(riff.tonalDisplay, width: 130, height: 40, x: 15, y: 104)
            Image(systemName: "chevron.down")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(hex: "5C45B7"))
                .offset(x: 110, y: 120)

            field("\(riff.bpm)", width: 80, height: 40, x: 155, y: 104)

            Text("\(riff.bpm) BPM")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "6A46F3"))
                .offset(x: 245, y: 97)

            ZStack(alignment: .leading) {
                Capsule().fill(Color(hex: "251B4D")).frame(width: 110, height: 4)
                Capsule().fill(Color(hex: "5C45B7")).frame(width: 50, height: 4)
                Circle().fill(.white).frame(width: 12, height: 12).overlay(Circle().stroke(Color(hex: "6A46F3"), lineWidth: 3)).offset(x: 40)
            }
            .offset(x: 245, y: 115)

            HStack {
                Text("60")
                Spacer()
                Text("200")
            }
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(Color(hex: "5C45B7"))
            .frame(width: 110)
            .offset(x: 244, y: 126)

            Text("CHORD SEQUENCE (UP TO 16 BARS)").section().offset(x: 15, y: 163)
            chordsRow.offset(x: 15, y: 190)

            ZStack(alignment: .leading) {
                Capsule().fill(Color(hex: "251B4D")).frame(width: 340, height: 4)
                Capsule().fill(Color(hex: "5C45B7")).frame(width: 315, height: 4)
            }
            .offset(x: 15, y: 240)

            Text("Note").section().offset(x: 15, y: 256)

            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "0C0D0D"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
                .frame(width: 340, height: 170)
                .offset(x: 15, y: 283)

            Text(riff.note.isEmpty ? "No notes yet." : riff.note)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "6A46F3"))
                .frame(width: 318, height: 150, alignment: .topLeading)
                .offset(x: 26, y: 292)
        }
    }

    private var chordsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(riff.chords) { chord in
                    chordCell(chord.displayTitle)
                }
            }
            .frame(height: 40)
            .padding(.trailing, 8)
        }
        .frame(width: 340, alignment: .leading)
        .clipped()
    }

    private func chordCell(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color(hex: "6A46F3"))
            .frame(width: 44, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "0C0D0D"))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
            )
    }

    private func field(_ text: String, width: CGFloat, height: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color(hex: "6A46F3"))
            .padding(.horizontal, 11)
            .frame(width: width, height: height, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "0C0D0D"))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
            )
            .offset(x: x, y: y)
    }

    private func actionButton(title: String, icon: String? = nil, assetIcon: String? = nil, bg: Color, border: Color, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .medium))
                }
                if let assetIcon {
                    Image(assetIcon)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                Text(title)
                    .font(.system(size: 15, weight: .medium))
            }
            .foregroundStyle(.white)
            .frame(width: 170, height: 50)
            .background(RoundedRectangle(cornerRadius: 10).fill(bg).overlay(RoundedRectangle(cornerRadius: 10).stroke(border, lineWidth: 1)))
        }
        .buttonStyle(.soundPlain)
    }
}

private extension Text {
    func section() -> some View {
        self.font(.custom("Bebas Neue", size: 20)).foregroundStyle(.white)
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

