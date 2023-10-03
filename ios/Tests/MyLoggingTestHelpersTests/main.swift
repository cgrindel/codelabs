#if os(Linux)
  import XCTest

  XCTMain([
    testCase(TestLoggerProviderTests.allTests),
  ])
#endif
