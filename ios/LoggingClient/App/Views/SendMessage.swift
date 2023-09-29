import SwiftUI

struct SendMessage: View {
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
    }
}
