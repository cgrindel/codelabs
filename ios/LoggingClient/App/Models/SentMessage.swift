import Foundation

struct SentMessage: Identifiable {
    var message: String
    var id = UUID()
    var date: Date = .init()
}
