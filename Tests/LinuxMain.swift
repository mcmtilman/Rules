import XCTest

import RulesTests

var tests = [XCTestCaseEntry]()

tests += ExpressionsTests.allTests()
tests += FunctionsTests.allTests()
tests += PredicatesTests.allTests()
 
XCTMain(tests)
