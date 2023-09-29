import Combine
import Foundation

class ModelData: ObservableObject {
    @Published var host: String
    @Published var port: Int

    init(host: String = "", port: Int = 0) {
        self.host = host
        self.port = port
    }
}
