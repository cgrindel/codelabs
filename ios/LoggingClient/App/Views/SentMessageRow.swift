import SwifterSwift
import SwiftUI

struct SentMessageRow: View {
    @EnvironmentObject var modelData: ModelData
    var sentMsg: SentMessage

    var body: some View {
        HStack {
            Text(sentMsg.message)
            Spacer()
            Text(sentMsg.date.string(withFormat: "MM/dd/yy HH:mm"))
        }
    }
}

struct SentMessageRow_Previews: PreviewProvider {
    static var previewData = ModelData.previewData()

    static var previews: some View {
        Group {
            SentMessageRow(sentMsg: previewData.sentMsgs[0])
            SentMessageRow(sentMsg: previewData.sentMsgs[1])
        }
        .environmentObject(previewData)
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
