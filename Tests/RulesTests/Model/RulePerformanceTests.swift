//
//  RulePerformanceTests.swift
//  RulesTests
//
//  Created by Michel Tilman on 27/01/2020.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

import XCTest
import Rules

/**
 Tests rule evaluation performance.
 */
class RulePerformanceTests: XCTestCase {

    // MARK: Testing basic rules
    
    // Test performance of a condition-assertion rule.
    func testConditionAssertionRule() {
        struct X {
            let i = 0, s = "string", c = true
        }
        let assertion = And(EQ(\X.i, 0), IsPrefix("str", \X.s))
        let rule = ConditionAssertionRule(name: "Rule", condition: \X.c, assertion: assertion)
        let context = X()

        self.measure {
            for _ in 1 ... 1000 {
               _ = try? rule.eval(in: context)
            }
        }
    }

    // MARK: Testing rule sets
    
    // Test performance of a simple rule set with one rule.
    func testSimpleRuleSet() {
        struct X {
            let i = 0, s = "string", rc = true, rsc = true
        }
        let assertion = And(EQ(\X.i, 0), IsPrefix("str", \X.s))
        let rule = ConditionAssertionRule(name: "Rule", condition: \X.rc, assertion: assertion)
        let ruleSet = RuleSet(name: "Rule set", condition: \X.rsc, rules: [rule])
        let context = X()

        self.measure {
            for _ in 1 ... 1000 {
               _ = try? ruleSet.eval(in: context)
            }
        }
    }

}


/**
 Standard predicates.
 */
extension RulePerformanceTests {
    
    typealias And = Predicate.And
    typealias EQ = Predicate.IsEqual
    typealias IsPrefix = Predicate.IsPrefix

}


/**
 Rule performance test suite.
 */
extension RulePerformanceTests {
    
    static var allTests = [
        ("testConditionAssertionRule", testConditionAssertionRule),
        ("testSimpleRuleSet", testSimpleRuleSet),
    ]
    
}
