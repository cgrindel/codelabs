import Foundation
import schema_logger_logger_client_swift_grpc

public struct MostRecentLogger {
    public struct Message: Equatable {
        public var date: Date
        public var level: Level
        public var message: String

        public init(date: Date, level: Level, message: String) {
            self.date = date
            self.level = level
            self.message = message
        }
    }

    public var maxMessages: Int
    public var level: Level

    public private(set) var messages: [Message] = []
    private let dateProvider: () -> Date

    public init(dateProvider: @escaping () -> Date, maxMessages: Int, level: Level = .info) {
        self.dateProvider = dateProvider
        self.maxMessages = maxMessages
        self.level = level
    }

    mutating func add(_ msg: Message) {
        messages.append(msg)
        if messages.count > maxMessages {
            messages.removeFirst()
        }
    }
}

extension MostRecentLogger: LoggerProtocol {
    public mutating func log(level: Level, _ message: @autoclosure () -> String) {
        let msg = Message(date: dateProvider(), level: level, message: message())
        add(msg)
    }
}
