//
//  RuleTests.swift
//  RulesTests
//
//  Created by Michel Tilman on 19/01/2020.
//

import XCTest
import Rules

/**
 Tests rules.
 */
class RuleTests: XCTestCase {
    
    // MARK: Testing condition-assertion rules.
    
    // Test if a rule with false condition evaluates to nil.
    func testEvalFalseCondition() {
        XCTAssertNil(try ConditionAssertionRule(false, false).eval(in: ()))
        XCTAssertNil(try ConditionAssertionRule(false, true).eval(in: ()))
    }

    // Test if a rule with true condition evaluates to the assertion result.
    func testEvalTrueCondition() {
        XCTAssertFalse(try XCTUnwrap(try ConditionAssertionRule(true, false).eval(in: ())))
        XCTAssertTrue(try XCTUnwrap(try ConditionAssertionRule(true, true).eval(in: ())))
    }

}


/**
 Rule test suite.
 */
extension RuleTests {
    
    static var allTests = [
        ("testEvalFalseCondition", testEvalFalseCondition),
        ("testEvalTrueCondition", testEvalTrueCondition),
    ]

}
