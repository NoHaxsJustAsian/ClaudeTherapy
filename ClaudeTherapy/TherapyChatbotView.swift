import SwiftUI

struct TherapyChatbotView: View {
    @State private var messages: [ChatMessage] = [
        ChatMessage(sender: "Bot", content: "Hi! I'm here to help. How are you feeling today?")
    ]
    @State private var userInput: String = ""
    @State private var isSending: Bool = false // To show progress when sending a message
    
    @Environment(\.colorScheme) var colorScheme // Detect light or dark mode
    
    // LLM Service instance
    private let llmService = LLMService()
    
    var body: some View {
        VStack {
            // Chat messages view
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(messages) { message in
                        HStack {
                            if message.sender == "Bot" {
                                botMessageBubble(message.content)
                                Spacer()
                            } else {
                                Spacer()
                                userMessageBubble(message.content)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(colorScheme == .dark ? AppColors.darkBackground : AppColors.lightBackground)

            // Quick Suggestions (Floating Example Bubbles)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    quickSuggestionBubble("I'm feeling stressed")
                    quickSuggestionBubble("Can you give me advice?")
                    quickSuggestionBubble("How can I handle anxiety?")
                    quickSuggestionBubble("What is mindfulness?")
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)

            // Chat Input Section
            HStack {
                // Attachment Icons inside the bubble
                HStack(spacing: 12) {
                    chatIcon(name: "plus.circle") // Plus Icon
                    chatIcon(name: "photo.on.rectangle") // Photo Icon
                }

                // Text Field inside the bubble
                TextField("Chat with Therapist", text: $userInput)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .disabled(isSending) // Disable input while sending
                
                // Microphone/Send Button
                Button(action: sendMessage) {
                    Image(systemName: userInput.isEmpty ? "mic.fill" : "arrow.up.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(AppColors.accentColor)
                        .padding(8)
                        .background(AppColors.accentColor.opacity(0.2))
                        .clipShape(Circle())
                }
                .disabled(userInput.isEmpty || isSending) // Disable button if input is empty or sending
            }
            .padding(.horizontal)
            .background(colorScheme == .dark ? AppColors.botBubbleColorDark : AppColors.botBubbleColorLight)
            .cornerRadius(30)
            .padding(.horizontal)
            .shadow(color: colorScheme == .dark ? .black.opacity(0.2) : .gray.opacity(0.2), radius: 5, x: 0, y: 5)

            Spacer()
        }
        .background(colorScheme == .dark ? AppColors.darkBackground.edgesIgnoringSafeArea(.all) : AppColors.lightBackground.edgesIgnoringSafeArea(.all)) // Full-screen background
    }

    private func userMessageBubble(_ text: String) -> some View {
        Text(text)
            .padding()
            .background(AppColors.accentColor)
            .foregroundColor(.white)
            .cornerRadius(20)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
    }

    private func botMessageBubble(_ text: String) -> some View {
        Text(text)
            .padding()
            .background(colorScheme == .dark ? AppColors.botBubbleColorDark : AppColors.botBubbleColorLight)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .cornerRadius(20)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading)
    }

    private func quickSuggestionBubble(_ text: String) -> some View {
        Button(action: {
            userInput = text // Populate the text field with the suggestion
        }) {
            Text(text)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(colorScheme == .dark ? AppColors.botBubbleColorDark : AppColors.botBubbleColorLight)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func chatIcon(name: String) -> some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundColor(colorScheme == .dark ? .white : .gray)
    }

    private func sendMessage() {
        guard !userInput.isEmpty else { return }
        let currentInput = userInput
        
        // Add user message
        messages.append(ChatMessage(sender: "User", content: currentInput))
        userInput = "" // Clear input field
        isSending = true
        
        // Use Task for async/await
        Task {
            do {
                let response = try await llmService.sendMessageToLLM(messages: messages)
                
                // Update UI on main thread
                await MainActor.run {
                    messages.append(ChatMessage(sender: "Bot", content: response))
                    isSending = false
                }
            } catch {
                await MainActor.run {
                    messages.append(ChatMessage(sender: "Bot",
                        content: "I'm sorry, something went wrong: \(error.localizedDescription)"))
                    isSending = false
                }
            }
        }
    }
}

struct TherapyChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TherapyChatbotView().environment(\.colorScheme, .light) // Preview in light mode
            TherapyChatbotView().environment(\.colorScheme, .dark)  // Preview in dark mode
        }
    }
}
