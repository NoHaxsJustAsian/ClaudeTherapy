import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let sender: String
    let content: String
}
