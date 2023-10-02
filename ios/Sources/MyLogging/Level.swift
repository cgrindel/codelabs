public enum Level: Equatable {
    case info
    case warning
    case error
}

public extension Level {
    func shouldLog(_ level: Level) -> Bool {
        switch self {
        case .info:
            return true
        case .warning:
            return level == .warning || level == .error
        case .error:
            return level == .error
        }
    }
}
