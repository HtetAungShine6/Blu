import SwiftUI

extension Font {
    func toUIFont() -> UIFont {
        switch self {
        case .largeTitle: return UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title: return UIFont.preferredFont(forTextStyle: .title1)
        case .title2: return UIFont.preferredFont(forTextStyle: .title2)
        case .title3: return UIFont.preferredFont(forTextStyle: .title3)
        case .headline: return UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline: return UIFont.preferredFont(forTextStyle: .subheadline)
        case .body: return UIFont.preferredFont(forTextStyle: .body)
        case .callout: return UIFont.preferredFont(forTextStyle: .callout)
        case .footnote: return UIFont.preferredFont(forTextStyle: .footnote)
        case .caption: return UIFont.preferredFont(forTextStyle: .caption1)
        default: return UIFont.systemFont(ofSize: 16)
        }
    }
}

