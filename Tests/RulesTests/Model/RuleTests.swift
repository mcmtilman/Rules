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
    
    // Test if a non-matching rule evaluates to nil.
    func testEvalNonMatchingCARule() {
        XCTAssertNil(try ConditionAssertionRule(name: "Rule", condition: false, assertion: false).eval(in: ()))
        XCTAssertNil(try ConditionAssertionRule(name: "Rule", condition: false, assertion: true).eval(in: ()))
    }

    // Test if a matching rule evaluates to the assertion result.
    func testEvalMatchingCARule() {
        XCTAssertFalse(try XCTUnwrap(try ConditionAssertionRule(name: "Rule", condition: true, assertion: false).eval(in: ())))
        XCTAssertTrue(try XCTUnwrap(try ConditionAssertionRule(name: "Rule", condition: true, assertion: true).eval(in: ())))
    }

    // MARK: Testing rule sets.
    
    // Test if a non-matching ruleset evaluates to nil.
    func testEvalNonMatchingRuleSet() {
        let rule = ConditionAssertionRule(name: "Rule", condition: true, assertion: false)
        let ruleSet = RuleSet(name: "Rule set", condition: false, rules: [rule])
        
        XCTAssertNil(try ruleSet.eval(in: ()))
    }

    // Test if a non-empty matching ruleset evaluates to nil.
    func testEvalMatchingRuleSet() throws {
        let rule = ConditionAssertionRule(name: "Rule", condition: true, assertion: true)
        let ruleSet = RuleSet(name: "Rule set", condition: true, rules: [rule])
        
        guard let result = try ruleSet.eval(in: ()) else { return XCTFail("nill result") }
        
        XCTAssertTrue(result)
    }

    // Test if (matching) empty rulesets evaluate to nil.
    func testEvalEmptyRuleSet() throws {
        let ruleSetMatchAll = RuleSet(name: "Rule set", condition: true, rules: [ConditionAssertionRule<Bool, Bool>]())
        let ruleSetMatchFirst = RuleSet(name: "Rule set", condition: true, rules: [ConditionAssertionRule<Bool, Bool>](), matchAll: false)

        XCTAssertNil(try ruleSetMatchAll.eval(in: ()))
        XCTAssertNil(try ruleSetMatchFirst.eval(in: ()))
    }

}


/**
 Rule test suite.
 */
extension RuleTests {
    
    static var allTests = [
        ("testEvalNonMatchingCARule", testEvalNonMatchingCARule),
        ("testEvalMatchingCARule", testEvalMatchingCARule),
        ("testEvalNonMatchingRuleSet", testEvalNonMatchingRuleSet),
        ("testEvalMatchingRuleSet", testEvalMatchingRuleSet),
        ("testEvalEmptyRuleSet", testEvalEmptyRuleSet),
    ]

}
