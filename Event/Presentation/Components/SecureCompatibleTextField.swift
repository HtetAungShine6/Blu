import SwiftUI

struct SecureCompatibleTextField: UIViewRepresentable {
  @Binding var text: String
  var placeholder: String
  var isSecureEntry: Bool
  var font: Font = .body
  var textColor: UIColor = .label
  
  class Coordinator: NSObject, UITextFieldDelegate {
    var parent: SecureCompatibleTextField
    var updateCharacterTask: Task<Void, Never>?
    
    init(_ parent: SecureCompatibleTextField) {
      self.parent = parent
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      updateCharacterTask?.cancel()
      
      if let textRange = Range(range, in: parent.text) {
        let updatedText = parent.text.replacingCharacters(in: textRange, with: string)
        parent.text = updatedText
      }
      return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      updateCharacterTask?.cancel()
      parent.text = ""
      return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }
  }
  
  func makeUIView(context: Context) -> UITextField {
    let tf = UITextField()
    tf.delegate = context.coordinator
    tf.placeholder = placeholder
    tf.font = font.toUIFont()
    tf.textColor = textColor
    tf.returnKeyType = .done
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    
    tf.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    tf.setContentHuggingPriority(.defaultLow, for: .horizontal)
    
    setText(for: tf, coordinator: context.coordinator)
    return tf
  }
  
  func updateUIView(_ uiView: UITextField, context: Context) {
    uiView.placeholder = placeholder
    setText(for: uiView, coordinator: context.coordinator)
  }
  
  private func setText(for textField: UITextField, coordinator: Coordinator) {
    coordinator.updateCharacterTask?.cancel()
    if isSecureEntry {
      let securedText = String(repeating: "•", count: text.count)
      
      if (textField.text?.count ?? 0) < text.count {
        var partiallyHidden = securedText
        partiallyHidden.removeLast()
        textField.text = partiallyHidden + text.suffix(1)
        
        coordinator.updateCharacterTask = Task { [securedText] in
          try? await Task.sleep(nanoseconds: 400_000_000)
          if !Task.isCancelled {
            await MainActor.run { textField.text = securedText }
          }
        }
      } else {
        textField.text = securedText
      }
    } else {
      textField.text = text
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}
