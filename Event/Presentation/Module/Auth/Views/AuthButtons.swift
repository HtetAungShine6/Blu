import SwiftUI

struct EmailAuthButton: View {
  let useInSignIn: Bool
  let action: () -> Void
  var body: some View {
    if useInSignIn {
      AppButton(config: ButtonConfig(
          type: .primary,
          title: "SIGN IN",
          icon: "arrow.right",
          iconPosition: .right,
          width: 300,
          height: 50,
          backgroundColor: .accent,
          action: action
      ))
    } else {
      AppButton(config: ButtonConfig(
          type: .primary,
          title: "SIGN UP",
          icon: "arrow.right",
          iconPosition: .right,
          width: 300,
          height: 50,
          backgroundColor: .accent,
          action: action
      ))
    }
  }
}

struct GoogleAuthButton: View {
  let action: () -> Void
  var body: some View {
    AppButton(config: ButtonConfig(
      type: .primary,
      title: "Login with Google",
      fontStyle: .body1,
      icon: "GoogleIconLight",
      iconPosition: .left,
      width: 300,
      height: 50,
      backgroundColor: .textWhite,
      foregroundColor: .textPrimaryDark,
      action: action
    ))
    .padding(.bottom, .spacer10)
  }
}

struct AuthNavigatorButton: View {
  let useInSignIn: Bool
  let action: () -> Void
  var body: some View {
    HStack(spacing: 0) {
      Label(useInSignIn ? "Don't have an account?" : "Already have an account?")
        .font(.small1)
      AppButton(config: ButtonConfig(
        type: .link,
        title: useInSignIn ? "Sign Up" : "Sign In",
        fontStyle: .small1,
        horizontalPadding: .spacer2,
        foregroundColor: .accent,
        action: action
      ))
    }
  }
}
