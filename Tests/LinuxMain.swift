import XCTest

import RulesTests

var tests = [XCTestCaseEntry]()

tests += ContextTests.allTests()
tests += ExpressionTests.allTests()
tests += FunctionTests.allTests()
tests += PredicateTests.allTests()
tests += RuleTests.allTests()

XCTMain(tests)
