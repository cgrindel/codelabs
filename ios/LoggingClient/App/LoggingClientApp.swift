//
//  LoggingClientApp.swift
//  LoggingClient
//
//  Created by Chuck Grindel on 9/29/23.
//

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
