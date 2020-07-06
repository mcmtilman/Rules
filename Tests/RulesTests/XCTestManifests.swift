import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ContextTests.allTests),
        testCase(ExpressionTests.allTests),
        testCase(FunctionTests.allTests),
        testCase(PredicateTests.allTests),
        testCase(RuleTests.allTests),
    ]
}
#endif
