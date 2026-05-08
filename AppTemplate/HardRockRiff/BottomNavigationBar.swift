import SwiftUI

struct BottomNavigationBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 81, style: .continuous)
                .fill(Color(red: 0.08, green: 0.08, blue: 0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 81, style: .continuous)
                        .stroke(Color(red: 0.17, green: 0.16, blue: 0.16), lineWidth: 1)
                )

            navButton(.moodTracker, x: 13, y: 7, w: 86, h: 42, iconSize: 20)
            navButton(.home, x: 102, y: 6, w: 86, h: 48, iconSize: 22)
            navButton(.calendar, x: 183, y: 5, w: 86, h: 49, iconSize: 20)
            navButton(.stats, x: 271, y: 7, w: 86, h: 47, iconSize: 20)
        }
    }

    private func navButton(_ tab: AppTab, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, iconSize: CGFloat) -> some View {
        let isSelected = selectedTab == tab

        return Button {
            ButtonTapFeedback.play()
            selectedTab = tab
        } label: {
            VStack(spacing: 0) {
                Image(tabIconAssetName(for: tab))
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: iconSize, height: 24)
                Text(tab.title)
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(1)
            }
            .foregroundStyle(isSelected ? Color(red: 0.42, green: 0.27, blue: 0.95) : .white)
            .frame(width: w, height: h)
        }
        .buttonStyle(.soundPlain)
        .offset(x: x, y: y)
    }

    private func tabIconAssetName(for tab: AppTab) -> String {
        switch tab {
        case .moodTracker:
            return "Vector-7"
        case .home:
            return "Vector-4"
        case .calendar:
            return "Group-2"
        case .stats:
            return "Vector-5"
        }
    }
}
