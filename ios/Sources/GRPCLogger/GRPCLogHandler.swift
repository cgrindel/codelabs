import Logging

public struct GRPCLogHandler: LogHandler {
    public func log(
        level _: Logger.Level,
        message _: Logger.Message,
        metadata _: Logger.Metadata?,
        source _: String,
        file _: String,
        function _: String,
        line _: UInt
    ) {
        // TODO: IMPLEMENT ME!
    }

    public subscript(metadataKey _: String) -> Logger.Metadata.Value? {
        get {
            // TODO: IMPLEMENT ME!
            return nil
        }
        set {
            // TODO: IMPLEMENT ME!
        }
    }

    public var metadata: Logger.Metadata = [:]

    public var logLevel: Logger.Level = .info
}
