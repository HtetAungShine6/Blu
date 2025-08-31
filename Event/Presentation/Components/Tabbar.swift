import SwiftUI

struct Tabbar: View {
  @Binding var selectedTab: Tabs
  var onTabSelected: (Tabs) -> Void
  
  @Environment(\.colorScheme) private var colorScheme
  
  var body: some View {
    HStack {
      ForEach(Tabs.allCases, id: \.self) { tab in
        Button(action: {
          
          let generator = UIImpactFeedbackGenerator(style: .light)
          generator.prepare()
          generator.impactOccurred()
          
          withAnimation(.easeInOut) {
            selectedTab = tab
            onTabSelected(tab)
          }
        }) {
          VStack {
            Image(systemName: tab.icon)
              .font(.system(size: 22, weight: .semibold))
              .foregroundColor(selectedTab == tab ? .blue : .gray)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
      }
    }
    .padding(.horizontal, 30)
    .padding(.vertical, 12)
    .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground).opacity(0.8) : Color.white)
    .clipShape(Capsule())
    .shadow(color: colorScheme == .dark ? .defaultBorder.opacity(0.1) : Color.black.opacity(0.06), radius: 4, x: 0, y: 0)
    .shadow(color: colorScheme == .dark ? .defaultBorder.opacity(0) : Color.black.opacity(0.6), radius: 0.1, x: 0, y: 0)
    .padding(.bottom, 24)
    .padding(.horizontal)
  }
}

struct Tabbar_Previews: PreviewProvider {
  @State static var selected: Tabs = .home
  
  static var previews: some View {
    Tabbar(selectedTab: $selected) { tab in
      print("Selected tab: \(tab)")
    }
    .padding()
    .previewLayout(.sizeThatFits)
    .preferredColorScheme(.light)
  }
}
