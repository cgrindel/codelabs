import SwiftUI

struct SendMessage: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showEditConnection = false
    @State var message = ""

    var sortedSentMsgs: [SentMessage] {
        modelData.sentMsgs.sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Connection") {
                    HStack {
                        Image(systemName: "wifi.square.fill")
                            .foregroundColor(.blue)
                        Text("\(modelData.host) : \(String(format: "%d", modelData.port))")
                        Spacer()
                        Button("Edit") {
                            showEditConnection.toggle()
                        }
                    }
                }
                Section("Log Message") {
                    HStack {
                        TextField("Message", text: $message)
                            .onSubmit {
                                sendMessage()
                            }
                        Spacer()
                        Button {
                            sendMessage()
                        } label: {
                            Image(systemName: "paperplane")
                        }
                        .disabled(isInvalid)
                    }
                }
                Section("History") {
                    List(sortedSentMsgs) { sentMsg in
                        SentMessageRow(sentMsg: sentMsg)
                    }
                }
            }
            .sheet(isPresented: $showEditConnection) {
                EditConnection(host: modelData.host, port: modelData.port)
            }
        }
    }

    var isInvalid: Bool {
        message.isEmpty
    }

    func sendMessage() {
        guard !isInvalid else {
            return
        }
        modelData.sendLogMessage(message)
        message = ""
    }
}

struct SendMessage_Previews: PreviewProvider {
    static var previews: some View {
        SendMessage()
            .environmentObject(ModelData.previewData())
    }
}
