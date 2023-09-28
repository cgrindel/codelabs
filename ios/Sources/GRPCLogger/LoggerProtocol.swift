public protocol LoggerProtocol {
    mutating func log(level: Level, message: @autoclosure () -> String)
}

public extension LoggerProtocol {
    mutating func info(_ message: @autoclosure () -> String) {
        log(level: .info, message: message())
    }

    mutating func warning(_ message: @autoclosure () -> String) {
        log(level: .warning, message: message())
    }

    mutating func error(_ message: @autoclosure () -> String) {
        log(level: .error, message: message())
    }
}
