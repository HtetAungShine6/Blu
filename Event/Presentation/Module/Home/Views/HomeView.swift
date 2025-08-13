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
//        OTPBoxes(otp: $otp, isFocused: $isFocusedOtp)
        OTPBoxes(otp: $otp)
        AppButton(config: ButtonConfig(
          title: "Show OTP Code",
          icon: "arrow.right",
          type: .primary,
          width: 300,
          height: 50,
          fontSize: .button1,
          backgroundColor: .accent,
          action: {
            print("\(otp))")
          }))
//        
//        TextBox(config: TextBoxConfig(
//          placeholder: "Password Sign In",
//          icon: "lock",
//          type: .secure,
//          text: $passwordSignIn,
//          width: 365,
//          height: 60,
//          font: .body1,
//          strokeColor: .textSecondaryDark,
//          validationMessage: "Wrong password",
//          showValidation: toggleValidation
//        ), isFocused: $isFocusedSignIn)
//        
//        Button("Sign In") {
//          toggleValidation.toggle()
//        }
//        
//        TextBox(config: TextBoxConfig(
//          placeholder: "Password Sign Up",
//          icon: "lock",
//          type: .secure,
//          useInSignUp: true,
//          text: $passwordSignUp,
//          width: 365,
//          height: 60,
//          font: .body1,
//          strokeColor: .textSecondaryDark
//        ), isFocused: $isFocusedSignUp)
//        
//        Text("Hello KOKO MGMG KO Shine:")
//        
//        Button("Go to Home Detail") {
//          navigator.push(.homeDetail)
//        }
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
