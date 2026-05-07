import SwiftUI

struct HomeSecondStateView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Image("Frame 94036-2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()

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
                        .frame(width: 370, height: 470)
                        .offset(x: 10, y: 131)

                    Image("Group 10")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 194)
                        .opacity(0.9)
                        .offset(x: 97, y: 600)
                }
                .frame(width: 390, height: 844, alignment: .topLeading)
                .offset(x: max(0, (proxy.size.width - 390) / 2), y: max(0, (proxy.size.height - 844) / 2))
                .clipped()
            }
        }
        .clipped()
    }

    private var createCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(hex: "141414"))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color(hex: "2C2A2A"), lineWidth: 1)
                )

            Circle()
                .fill(Color(hex: "6A46F3"))
                .frame(width: 8, height: 8)
                .offset(x: 15, y: 24)

            Text("Create Riff")
                .font(.custom("Bebas Neue", size: 20))
                .foregroundStyle(.white)
                .offset(x: 34, y: 18)

            field("Riff Name", width: 340, height: 40, x: 15, y: 52, opacity: 0.5, size: 13)

            Button {} label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                    Text("New Riff")
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "6A46F3"))
                .frame(width: 100, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "0C0D0D"))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
                )
            }
            .buttonStyle(.soundPlain)
            .offset(x: 255, y: 13)

            Text("KEY")
                .font(.custom("Bebas Neue", size: 20))
                .foregroundStyle(.white)
                .offset(x: 15, y: 108)

            Text("BPM")
                .font(.custom("Bebas Neue", size: 20))
                .foregroundStyle(.white)
                .offset(x: 155, y: 108)

            field("E minor", width: 130, height: 40, x: 15, y: 132, opacity: 1, size: 13)
            Image(systemName: "chevron.down")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color(hex: "5C45B7"))
                .rotationEffect(.degrees(-90))
                .offset(x: 120, y: 145)

            field("120", width: 80, height: 40, x: 155, y: 132, opacity: 1, size: 13)
            Image(systemName: "chevron.up")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color(hex: "5C45B7"))
                .offset(x: 216, y: 139)
            Image(systemName: "chevron.down")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color(hex: "5C45B7"))
                .offset(x: 216, y: 151)

            tempoBlock
                .offset(x: 245, y: 108)

            Text("CHORD SEQUENCE (UP TO 16 BARS)")
                .font(.custom("Bebas Neue", size: 20))
                .foregroundStyle(.white)
                .offset(x: 15, y: 188)

            chordsRow
                .offset(x: 15, y: 215)

            Text("Note")
                .font(.custom("Bebas Neue", size: 20))
                .foregroundStyle(.white)
                .offset(x: 15, y: 271)

            noteField("Add a note about this riff...", width: 340, height: 70, x: 15, y: 298, opacity: 0.5, size: 13)

            Button {} label: {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 16, weight: .medium))
                    Text("SAVE RIFF")
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundStyle(.white)
                .frame(width: 340, height: 50)
                .background(Color(hex: "6A46F3"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "8869FF"), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.soundPlain)
            .offset(x: 15, y: 390)
        }
    }

    private var chordsRow: some View {
        HStack(spacing: 5) {
            chordCell("Em", xOpacity: 0.5)
            chordCell("C", xOpacity: 0.5)
            chordCell("G", xOpacity: 0.5)
            chordCell("D", xOpacity: 0.5)
            chordCell("E", xOpacity: 0.5)
            chordCell("Cm", xOpacity: 0.5)
            chordCell("+", xOpacity: 1.0, dashed: true)
        }
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

    private var tempoBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TEMPO")
                .font(.custom("Bebas Neue", size: 20))
                .foregroundStyle(.white)
            Text("120 BPM")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "6A46F3"))
                .offset(y: -2)
            ZStack(alignment: .leading) {
                Capsule().fill(Color(hex: "251B4D")).frame(width: 110, height: 4)
                Capsule().fill(Color(hex: "5C45B7")).frame(width: 50, height: 4)
                Circle()
                    .fill(.white)
                    .frame(width: 12, height: 12)
                    .overlay(Circle().stroke(Color(hex: "6A46F3"), lineWidth: 3))
                    .offset(x: 40)
            }
            .offset(y: -2)
            HStack {
                Text("60")
                Spacer()
                Text("200")
            }
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(Color(hex: "5C45B7"))
            .frame(width: 110)
            .offset(y: -2)
        }
    }

    private func field(_ text: String, width: CGFloat, height: CGFloat, x: CGFloat, y: CGFloat, opacity: Double, size: CGFloat) -> some View {
        Text(text)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(Color(hex: "6A46F3").opacity(opacity))
            .padding(.horizontal, 11)
            .frame(width: width, height: height, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "0C0D0D"))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
            )
            .offset(x: x, y: y)
    }

    private func noteField(_ text: String, width: CGFloat, height: CGFloat, x: CGFloat, y: CGFloat, opacity: Double, size: CGFloat) -> some View {
        Text(text)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(Color(hex: "6A46F3").opacity(opacity))
            .frame(width: width - 22, height: height - 18, alignment: .topLeading)
            .padding(.horizontal, 11)
            .padding(.top, 9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "0C0D0D"))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2C2A2A"), lineWidth: 1))
            )
            .offset(x: x, y: y)
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

