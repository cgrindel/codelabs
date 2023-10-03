#if os(Linux)
  import XCTest

  XCTMain([
    testCase(GRPCLogHandlerTests.allTests),
    testCase(LevelTests.allTests),
    testCase(LoggerTests.allTests),
  ])
#endif
