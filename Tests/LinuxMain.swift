import XCTest

import RulesTests

var tests = [XCTestCaseEntry]()

tests += ExpressionTests.allTests()
 
XCTMain(tests)
