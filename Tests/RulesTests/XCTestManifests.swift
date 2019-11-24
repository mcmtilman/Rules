import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ExpressionsTests.allTests),
        testCase(FunctionsTests.allTests),
        testCase(PredicatesTests.allTests),
    ]
}
#endif
