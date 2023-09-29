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
                    TextField("Message", text: $message)
                }
            }
            .sheet(isPresented: $showEditConnection) {
                EditConnection(host: modelData.host, port: modelData.port)
            }
        }
    }
}

struct SendMessage_Previews: PreviewProvider {
    static var previews: some View {
        SendMessage()
            .environmentObject(ModelData.previewData())
    }
}
