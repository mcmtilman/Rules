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

    // Test if first matching rule is selected when multiple rules match.
    func testEvalMatchFirstRuleSet() throws {
        let nilRule = ConditionAssertionRule(name: "Nil rule", condition: false, assertion: true)
        let trueRule = ConditionAssertionRule(name: "True rule", condition: true, assertion: true)
        let falseRule = ConditionAssertionRule(name: "False rule", condition: true, assertion: false)
        let trueRuleSet = RuleSet(name: "True rule set", condition: true, rules: [nilRule, trueRule, falseRule], matchAll: false)
        let falseRuleSet = RuleSet(name: "False rule set", condition: true, rules: [nilRule, falseRule, trueRule], matchAll: false)

        guard let trueResult = try trueRuleSet.eval(in: ()), let falseResult = try falseRuleSet.eval(in: ()) else { return XCTFail("nill result") }
        
        XCTAssertTrue(trueResult)
        XCTAssertFalse(falseResult)
    }

    // Test evaluating a rule set with multiple matching rules.
    func testEvalMatchAllRuleSet() throws {
        let nilRule = ConditionAssertionRule(name: "Nil rule", condition: false, assertion: true)
        let trueRule = ConditionAssertionRule(name: "True rule", condition: true, assertion: true)
        let falseRule = ConditionAssertionRule(name: "False rule", condition: true, assertion: false)
        let trueRuleSet = RuleSet(name: "True rule set", condition: true, rules: [nilRule, trueRule, nilRule, trueRule, nilRule])
        let falseRuleSet = RuleSet(name: "False rule set", condition: true, rules: [nilRule, trueRule, nilRule, falseRule, nilRule])

        guard let trueResult = try trueRuleSet.eval(in: ()), let falseResult = try falseRuleSet.eval(in: ()) else { return XCTFail("nill result") }
        
        XCTAssertTrue(trueResult)
        XCTAssertFalse(falseResult)
    }

    // Test evaluating a rule set with matching nested rule set evaluating to true.
    func testEvalNestedRuleSet() throws {
        let nilRule = ConditionAssertionRule(name: "Nil rule", condition: false, assertion: true)
        let trueRule = ConditionAssertionRule(name: "True rule", condition: true, assertion: true)
        let childRuleSet = RuleSet(name: "Child rule set", condition: true, rules: [nilRule, trueRule, nilRule])
        let parentRuleSet = RuleSet(name: "Parent rule set", condition: true, rules: [nilRule, childRuleSet, trueRule, nilRule])

        guard let result = try parentRuleSet.eval(in: ()) else { return XCTFail("nill result") }
        
        XCTAssertTrue(result)
    }

    // Test evaluating a rule set with matching nested rule set evaluating to nil.
    func testEvalNilNestedRuleSet() throws {
        let rule = ConditionAssertionRule(name: "Nil rule", condition: false, assertion: true)
        let childRuleSet = RuleSet(name: "Child rule set", condition: true, rules: [rule])
        let parentRuleSet = RuleSet(name: "Parent rule set", condition: true, rules: [childRuleSet])

        XCTAssertNil(try parentRuleSet.eval(in: ()))
    }

    // Test evaluating a rule set with non-matching nested rule set.
    func testEvalNonMatchingNestedRuleSet() throws {
        let rule = ConditionAssertionRule(name: "Rule", condition: true, assertion: true)
        let childRuleSet = RuleSet(name: "Child rule set", condition: false, rules: [rule])
        let parentRuleSet = RuleSet(name: "Parent rule set", condition: true, rules: [childRuleSet])

        XCTAssertNil(try parentRuleSet.eval(in: ()))
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
        ("testEvalMatchFirstRuleSet", testEvalMatchFirstRuleSet),
        ("testEvalMatchAllRuleSet", testEvalMatchAllRuleSet),
        ("testEvalNestedRuleSet", testEvalNestedRuleSet),
        ("testEvalNilNestedRuleSet", testEvalNilNestedRuleSet),
        ("testEvalNonMatchingNestedRuleSet", testEvalNonMatchingNestedRuleSet),
    ]

}
