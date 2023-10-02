import Foundation

public protocol LogHandler {
    func log(_ message: Logger.Message)
    var logLevel: Level { get set }
}
