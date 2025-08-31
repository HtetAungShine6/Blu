import SwiftUI
import Navio

struct HomeView<ViewModel: HomeViewModel>: View {
  
  let navigator: HomeNavigator
  let tab: TabNavigator
  @StateObject private var viewModel: ViewModel
//  @State private var passwordSignIn: String = ""
//  @State private var passwordSignUp: String = ""
//  @State private var toggleValidation: Bool = false
//  @FocusState private var isFocusedSignIn: Bool
//  @FocusState private var isFocusedSignUp: Bool
  
  @FocusState private var isFocusedOtp: Bool
  
  @State private var otp = Array(repeating: "", count: 4)
//  @State private var otp: String = ""
  
  init(
    viewModel: @autoclosure @escaping () -> ViewModel,
    navigator: HomeNavigator,
    tab: TabNavigator
  ){
    _viewModel = StateObject(wrappedValue: viewModel())
    self.navigator = navigator
    self.tab = tab
  }
  
  var body: some View {
    ZStack {
      Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
          //          isFocusedSignIn = false
          //          isFocusedSignUp = false
          isFocusedOtp = false
        }
      VStack {
        Text("Hello, World!")
      }
    }
    .toolbar {
      ToolbarItem {
        Button {
          viewModel.signOut()
        } label: {
          Image(systemName: "door.left.hand.open")
        }
      }
    }
  }
}
