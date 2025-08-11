enum HomeRoute: Hashable {
    case homeDetail
}

enum EventRoute: Hashable {
    case event
}

enum SettingRoute: Hashable {
    case setting
}

enum ProfileRoute: Hashable {
    case profile
}


enum Tabs: Hashable, CaseIterable {
    case home
    case event
    case settings
    case profile
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .event:
            return "calendar"
        case .settings:
            return "gear"
        case .profile:
            return "person"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .event: 
            return "Event"
        case .settings: 
            return "Settings"
        case .profile:
            return "Profile"
        }
    }
}
