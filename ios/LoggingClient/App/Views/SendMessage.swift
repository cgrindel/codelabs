import SwiftUI

struct SendMessage: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct SendMessage_Previews: PreviewProvider {
    static var previews: some View {
        SendMessage()
            .environmentObject(ModelData.previewData())
    }
}
