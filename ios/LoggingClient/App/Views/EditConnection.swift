import SwiftUI

struct EditConnection: View {
    @EnvironmentObject var modelData: ModelData
    @State var host: String
    @State var port: Int
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("Connection") {
                    LabeledContent {
                        TextField("Host", text: $host)
                            .accessibilityIdentifier("hostTextField")
                    } label: {
                        Text("Host")
                    }
                    LabeledContent {
                        TextField("Port", text: Binding(
                            get: { String(self.port) },
                            set: { self.port = Int($0) ?? 0 }
                        ))
                        .accessibilityIdentifier("portTextField")
                    } label: {
                        Text("Port")
                    }
                }
                .multilineTextAlignment(.trailing)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: cancel) {
                        Text("Cancel")
                    }
                    .accessibilityIdentifier("cancelConnectionButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: save) {
                        Text("Save")
                    }
                    .disabled(isInvalid)
                    .accessibilityIdentifier("saveConnectionButton")
                }
            }
        }
    }

    var isInvalid: Bool {
        host == "" || port < 0
    }

    func cancel() {
        dismiss()
    }

    func save() {
        modelData.setConnectionInfo(host: host, port: port)
        dismiss()
    }
}

struct EditConnection_Previews: PreviewProvider {
    static var previewData = ModelData.previewData()

    static var previews: some View {
        EditConnection(host: previewData.host, port: previewData.port)
            .environmentObject(previewData)
    }
}
