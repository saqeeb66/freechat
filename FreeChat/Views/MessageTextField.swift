//
//  MessageTextField.swift
//  Chats
//
//  Created by Peter Sugihara on 8/5/23.
//

import SwiftUI

struct ChatStyle: TextFieldStyle {
  @FocusState private var isFocused: Bool
  @Environment(\.colorScheme) var colorScheme
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .textFieldStyle(.plain)
      .frame(maxWidth: .infinity)
      .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
      .padding(8)
      .cornerRadius(12)
      .focusable()
      .focused($isFocused)
      .overlay(
        RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.2), lineWidth: 1)
      )
  }
}

let chatStyle = ChatStyle()

struct MessageTextField: View {
  var conversation: Conversation
  var onSubmit: (String) -> Void

  @State private var input = ""
  @FocusState private var focused: Bool

  var body: some View {
    Group {
      TextField("Message", text: $input, axis: .vertical)
        .onSubmit {
          if CGKeyCode.kVK_Shift.isPressed {
            input += "\n"
          } else {
            onSubmit(input)
            input = ""
          }
        }
        .focused($focused)
        .textFieldStyle(chatStyle)
        .submitLabel(.send)
        .padding(.all, 10)
        .onAppear {
          maybeFocus(conversation)
        }
        .onChange(of: conversation) { nextConversation in
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            maybeFocus(nextConversation)
          }
        }
    }
    .background(.ultraThinMaterial)
  }
  
  
  
  private func maybeFocus(_ conversation: Conversation) {
    if conversation.createdAt == nil { return }
    let fiveSecondsAgo = Date() - TimeInterval(5) // 5 seconds ago
    if conversation.createdAt != nil, conversation.createdAt! >= fiveSecondsAgo, conversation.messages?.count == 0 {
      self.focused = true
    }
  }
}



//#if DEBUG
//struct MessageTextField_Previews: PreviewProvider {
//  static var previews: some View {
//    MessageTextField(conversation: c, onSubmit: { _ in print("submit") })
//      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//  }
//}
//#endif