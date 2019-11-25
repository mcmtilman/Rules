import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ExpressionTests.allTests),
        testCase(FunctionTests.allTests),
        testCase(PredicateTests.allTests),
    ]
}
#endif
