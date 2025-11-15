import Combine
import Foundation
import FoundationModels

final class ChatViewModel: ObservableObject {
  struct Message: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isMe: Bool
  }

  @Published var messages: [Message] = [
    Message(text: "Hi there!", isMe: false),
    Message(text: "Hello! This is a simple chat.", isMe: true),
  ]

  private var session: LanguageModelSession?

  private func getSession() -> LanguageModelSession {
    if let session { return session }
    let newSession = LanguageModelSession(
      instructions: "You are a helpful, friendly assistant. Be concise."
    )
    self.session = newSession
    return newSession
  }

  func send(_ text: String) {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    messages.append(Message(text: trimmed, isMe: true))
    Task {
      do {
        let reply = try await generateReply(to: trimmed)
        DispatchQueue.main.async {
          self.messages.append(Message(text: reply, isMe: false))
        }
      } catch {
        DispatchQueue.main.async {
          self.messages.append(
            Message(text: "Sorry, something went wrong.", isMe: false)
          )
        }
      }
    }
  }

  private func generateReply(to userText: String) async throws -> String {
    let session = getSession()
    // Provide a lightweight context with a system message and the user's message
    //        let messages: [LanguageModelMessage] = [
    //            .system(systemPrompt),
    //            .user(userMessage)
    //        ]
    //        let reply = try await session.complete(messages: messages)
    let reply = try await session.respond(to: userText)
    return reply.content.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
