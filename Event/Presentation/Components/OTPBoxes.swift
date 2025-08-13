import SwiftUI

struct OTPBoxes: View {
  @Binding var otp: [String]
  @FocusState private var focusedIndex: Int?
  
  private let length = 4
  
  var body: some View {
    HStack(spacing: .spacer10) {
      ForEach(0..<length, id: \.self) { index in
        OTPTextField(
          text: Binding(
            get: { otp[index] },
            set: { newValue in
              updateOTP(newValue, at: index)
            }
          ),
          onBackspace: {
            handleBackspace(at: index)
          }
        )
        .font(AppTheme.TextStyle.body1())
        .frame(width: 50, height: 65)
        .background(RoundedRectangle(cornerRadius: .radius3).stroke(focusedIndex == index ? .accent : .defaultBorder))
        .accentColor(.clear)
        .shadow(color: .accent, radius: 0.2, x: -0.15, y: 0.15)
        .focused($focusedIndex, equals: index)
      }
    }
    .onAppear {
      DispatchQueue.main.async {
        focusedIndex = 0
      }
    }
  }
}

#Preview {
  @Previewable @State var otp = Array(repeating: "", count: 4)
  OTPBoxes(otp: $otp)
}


extension OTPBoxes {
  private func handleBackspace(at index: Int) {
    if !otp[index].isEmpty {
      HapticPlayer.play(.rigid)
      otp[index] = ""
    }
    
    if index > 0 {
      focusedIndex = index - 1
    }
  }
  
  private func updateOTP(_ newValue: String, at index: Int) {
    let filtered = newValue.filter { $0.isNumber }
    guard filtered != otp[index] else { return }
    
    if filtered.count > 1 {
      HapticPlayer.play(.light)
      for (offset, char) in filtered.prefix(length - index).enumerated() {
        otp[index + offset] = String(char)
      }
      let nextIndex = index + filtered.count
      focusedIndex = nextIndex < length ? nextIndex : nil
    } else {
      HapticPlayer.play(.light)
      if filtered.isEmpty {
        let hadValue = !otp[index].isEmpty
        otp[index] = ""
        
        if hadValue && index > 0 {
          focusedIndex = index - 1
        }
      } else {
        otp[index] = filtered
        if index < length - 1 {
          focusedIndex = index + 1
        } else {
          focusedIndex = nil
        }
      }
    }
  }
}


//MARK: - OTP TextField
fileprivate struct OTPTextField: UIViewRepresentable {
  @Binding var text: String
  var onBackspace: () -> Void
  
  func makeUIView(context: Context) -> UITextField {
    let textField = BackspaceDetectingTextField()
    textField.delegate = context.coordinator
    textField.onBackspace = onBackspace
    textField.textAlignment = .center
    textField.keyboardType = .numberPad
    return textField
  }
  
  func updateUIView(_ uiView: UITextField, context: Context) {
    uiView.text = text
    uiView.textAlignment = .center
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, UITextFieldDelegate {
    let parent: OTPTextField
    
    init(_ parent: OTPTextField) {
      self.parent = parent
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
      parent.text = newText
      return false
    }
  }
}


//MARK: - Backspace detection to delete the state
fileprivate class BackspaceDetectingTextField: UITextField {
  var onBackspace: (() -> Void)?
  
  override func deleteBackward() {
    super.deleteBackward()
    onBackspace?()
  }
}
