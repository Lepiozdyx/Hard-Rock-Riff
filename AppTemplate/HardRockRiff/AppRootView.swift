import SwiftUI

enum AppTab: CaseIterable {
    case moodTracker
    case home
    case calendar
    case stats

    var title: String {
        switch self {
        case .moodTracker: return "Mood Tracker"
        case .home: return "Home"
        case .calendar: return "Calendar"
        case .stats: return "Stats"
        }
    }

    var systemImage: String {
        switch self {
        case .moodTracker: return "face.smiling"
        case .home: return "music.note.house"
        case .calendar: return "calendar"
        case .stats: return "chart.bar"
        }
    }
}

enum HomeScreenState {
    case list
    case details
}

struct AppRootView: View {
    @State private var selectedTab: AppTab = .home
    @State private var homeScreenState: HomeScreenState = .list
    @State private var selectedRiffID: UUID?
    @State private var editingRiffID: UUID?
    @StateObject private var store = AppDataStore()
    private let designSize = CGSize(width: 390, height: 844)
    private let designContentHeightBeforeNav: CGFloat = 755
    private let navDesignWidth: CGFloat = 370
    private let navDesignHeight: CGFloat = 60

    var body: some View {
        GeometryReader { proxy in
            let widthScale = proxy.size.width / designSize.width
            let isCompact = widthScale < 1
            ZStack(alignment: .topLeading) {
                Image("Frame 94036-2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()

                if isCompact {

                    let navBottomMargin: CGFloat = max(16, proxy.safeAreaInsets.bottom + 10)
                    let navTop = proxy.size.height - navDesignHeight - navBottomMargin
                    let contentYFit = min(1, navTop / designContentHeightBeforeNav)
                    let contentYScale = min(1, contentYFit * 1.03)
                    let contentXScale = min(1, widthScale)
                    let navScale = min(1, (proxy.size.width - 20) / navDesignWidth)

                    content
                        .frame(width: designSize.width, height: designSize.height)
                        .scaleEffect(x: contentXScale, y: contentYScale, anchor: .topLeading)
                        .frame(width: designSize.width * contentXScale, height: designSize.height * contentYScale, alignment: .topLeading)
                        .offset(x: (proxy.size.width - designSize.width * contentXScale) / 2, y: 0)

                    BottomNavigationBar(selectedTab: $selectedTab)
                        .frame(width: navDesignWidth, height: navDesignHeight)
                        .scaleEffect(navScale, anchor: .topLeading)
                        .frame(width: navDesignWidth * navScale, height: navDesignHeight * navScale, alignment: .topLeading)
                        .offset(
                            x: (proxy.size.width - navDesignWidth * navScale) / 2,
                            y: proxy.size.height - navDesignHeight * navScale - navBottomMargin
                        )
                } else {
                    let navBottomMargin = max(16, proxy.safeAreaInsets.bottom + 10)

                    content
                        .frame(width: designSize.width, height: designSize.height)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                    BottomNavigationBar(selectedTab: $selectedTab)
                        .frame(width: navDesignWidth, height: navDesignHeight)
                        .offset(
                            x: (proxy.size.width - navDesignWidth) / 2,
                            y: proxy.size.height - navDesignHeight - navBottomMargin
                        )
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
        .environmentObject(store)
    }

    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .home:
            switch homeScreenState {
            case .list:
                CreateRiffFirstStateView(
                    onOpenRiffDetails: { riff in
                        selectedRiffID = riff.id
                        homeScreenState = .details
                    },
                    editingRiff: editingRiff,
                    onFinishEditing: { updated in
                        selectedRiffID = updated.id
                        editingRiffID = nil
                        homeScreenState = .details
                    }
                )
            case .details:
                if let selectedRiff {
                    RiffDetailsView(riff: selectedRiff, onBack: {
                        homeScreenState = .list
                    }, onEdit: {
                        editingRiffID = selectedRiff.id
                        homeScreenState = .list
                    }, onDelete: {
                        store.deleteRiff(id: selectedRiff.id)
                        editingRiffID = nil
                        homeScreenState = .list
                    })
                } else {
                    Color.clear
                        .onAppear { homeScreenState = .list }
                }
            }
        case .moodTracker:
            MoodTrackerThirdStateView { date in
                store.selectedMonth = date
                store.selectedDate = date
                selectedTab = .calendar
            } onBackToHome: {
                selectedTab = .home
            }
        case .calendar:
            CalendarSecondStateView {
                selectedTab = .home
            }
        case .stats:
            StatsFirstStateView {
                selectedTab = .home
            }
        }
    }

    private var selectedRiff: RiffEntry? {
        guard let selectedRiffID else { return nil }
        return store.riffs.first(where: { $0.id == selectedRiffID })
    }

    private var editingRiff: RiffEntry? {
        guard let editingRiffID else { return nil }
        return store.riffs.first(where: { $0.id == editingRiffID })
    }
}

private struct PlaceholderTabView: View {
    let title: String

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
            Text("Screen is coming next.")
                .font(.subheadline)
                .foregroundStyle(Color.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    AppRootView()
}
