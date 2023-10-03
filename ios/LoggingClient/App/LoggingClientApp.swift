import SwiftUI

@main
struct LoggingClientApp: App {
    @State var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
