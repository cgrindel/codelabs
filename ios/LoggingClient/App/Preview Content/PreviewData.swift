import Foundation
import SwifterSwift

extension ModelData {
    static func previewData() -> ModelData {
        let modelData = ModelData()
        let date = Date()
        modelData.sentMsgs = [
            SentMessage(message: "Hello", date: date.adding(.second, value: -1)),
            SentMessage(message: "Goodbye", date: date.adding(.minute, value: -1)),
        ]
        return modelData
    }
}
