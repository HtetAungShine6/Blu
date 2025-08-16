import SwiftUI

struct AuthLabel: View {
  
  let title: String 
  
  var body: some View {
    HStack {
      Label(title)
        .font(.h2)
      Spacer()
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  AuthLabel(title: "SIGN IN")
}
