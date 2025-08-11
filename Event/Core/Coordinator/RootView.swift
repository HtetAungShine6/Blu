import SwiftUI
import Navio

struct RootView: View {
    
    @Navio<HomeRoute> var homeRoute
    @Navio<EventRoute> var eventRoute
    @Navio<SettingRoute> var settingsRoute
    @Navio<ProfileRoute> var profileRoute
    @Navio<Tabs> var appTab
    
    @State private var selectedTab: Tabs = .home
    @State private var isTabBarHidden = false
    
    private let homeViewModel = HomeViewModelImpl(authViewModel: AuthViewModelImpl(authRepository: AuthRepositoryImpl(googleOAuthService: GoogleOAuthServiceImpl())))
    
    var body: some View {
        ZStack(alignment: .bottom) {
            currentTabView
            VStack {
                Spacer()
                if !isTabBarHidden {
                    Tabbar(selectedTab: $selectedTab) { _ in
                        appTab.popToRoot()
                    }
                }
            }
            .ignoresSafeArea()
        }
        .onChange(of: selectedTab) { _, _ in
            updateTabBarVisibility()
        }
    }
}

extension RootView {
    @ViewBuilder
    private var currentTabView: some View {
        switch selectedTab {
        case .home:
            NavioView(homeRoute) {
                HomeView(viewModel: homeViewModel, navigator: homeRoute, tab: appTab)
            } route: { route in
                switch route {
                case .homeDetail:
                    HomeDetailView(navigator: homeRoute)
                }
            }
            .onChange(of: homeRoute.path.count) { _, _ in
                updateTabBarVisibility()
            }
        case .event:
            NavioView(eventRoute) {
                EventView(tab: appTab)
            } route: { route in
                switch route {
                case .event:
                    EventView(tab: appTab)
                }
            }
            .onChange(of: eventRoute.path.count) { _, _ in
                updateTabBarVisibility()
            }
        case .settings:
            NavioView(settingsRoute) {
                SettingsView(tab: appTab)
            } route: { route in
                switch route {
                case .setting:
                    SettingsView(tab: appTab)
                }
            }
            .onChange(of: settingsRoute.path.count) { _, _ in
                updateTabBarVisibility()
            }
        case .profile:
            NavioView(profileRoute) {
                ProfileView(tab: appTab)
            } route: { route in
                switch route {
                case .profile:
                    ProfileView(tab: appTab)
                }
            }
            .onChange(of: profileRoute.path.count) { _, _ in
                updateTabBarVisibility()
            }
        }
    }
    
    private func updateTabBarVisibility() {
        let stackCount: Int
        switch selectedTab {
        case .home:
            stackCount = homeRoute.path.count
        case .event:
            stackCount = eventRoute.path.count
        case .settings:
            stackCount = settingsRoute.path.count
        case .profile:
            stackCount = profileRoute.path.count
        }
        isTabBarHidden = stackCount > 0
    }
}
