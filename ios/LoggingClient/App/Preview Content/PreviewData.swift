extension ModelData {
    static func previewData() -> ModelData {
        let modelData = ModelData()
        modelData.sentMsgs = [
            SentMessage(message: "Hello"),
            SentMessage(message: "Goodbye"),
        ]
        return modelData
    }
}
