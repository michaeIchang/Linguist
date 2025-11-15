import SwiftUI
import FoundationModels
import Playgrounds

struct ContentView: View {
  @StateObject private var chatVM = ChatViewModel()
  var body: some View {
    ChatView(viewModel: chatVM)
  }
}

#Preview {
    ContentView()
}
