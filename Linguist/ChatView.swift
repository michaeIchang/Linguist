import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var inputText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.messages) { msg in
                            HStack {
                                if msg.isMe { Spacer(minLength: 32) }
                                Text(msg.text)
                                    .padding(12)
                                    .background(msg.isMe ? Color.accentColor.opacity(0.15) : Color.gray.opacity(0.15))
                                    .foregroundStyle(.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: msg.isMe ? .trailing : .leading)
                                if !msg.isMe { Spacer(minLength: 32) }
                            }
                            .frame(maxWidth: .infinity, alignment: msg.isMe ? .trailing : .leading)
                            .id(msg.id)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 12)
                }
                .onChange(of: viewModel.messages) { _, _ in
                    if let last = viewModel.messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
                .onAppear {
                    if let last = viewModel.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            Divider()

            HStack(spacing: 8) {
                TextField("Message", text: $inputText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...4)
                Button {
                    let text = inputText
                    inputText = ""
                    viewModel.send(text)
                } label: {
                    Image(systemName: "paperplane.fill")
                        .imageScale(.medium)
                }
                .buttonStyle(.borderedProminent)
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.all, 12)
            .background(.bar)
        }
        .navigationTitle("Chat")
    }
}

#Preview {
    ChatView(viewModel: ChatViewModel())
}
