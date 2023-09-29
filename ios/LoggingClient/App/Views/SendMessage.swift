import SwiftUI

struct SendMessage: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showEditConnection = false
    @State var message = ""

    var body: some View {
        NavigationView {
            Form {
                Section("Connection") {
                    HStack {
                        Image(systemName: "wifi.square.fill")
                            .foregroundColor(.blue)
                        Text("\(modelData.host) : \(modelData.port)")
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
        modelData.logger.info(message)
        message = ""
    }
}

struct SendMessage_Previews: PreviewProvider {
    static var previews: some View {
        SendMessage()
            .environmentObject(ModelData.previewData())
    }
}
