//
//  Rules.swift
//  Rules
//
//  Created by Michel Tilman on 23/11/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

/**
 Superclass for rules.
 A rule evalutes in a given context to true or false.
 The rule execution may depend on a pre-condition (the rule must *match* the context).
 If the rule pre-condition does not match the context, the result is nil.
*/
public class Rule {
    
    /// Returns the result of evaluating the rule in given context.
    /// The result is either true or false if the rule matches, or nil if there is no match.
    /// Collects statistics.
    public func eval<C>(in context: C, statistics: inout Statistics) throws -> Bool? {
        fatalError("Abstract method must be overridden")
    }

    /// Answer the result of evaluating the rule in given context.
    /// The result is either true or false if the rule matches, or nil if there is no match.
    public func eval<C>(in context: C) throws -> Bool? {
        var statistics = Statistics()
        
        return try eval(in: context, statistics: &statistics)
    }

}


/**
 Execution statistics.
*/
public struct Statistics {
    
    /// Total number of matched elementary rules.
    public fileprivate (set) var matchedRules = 0
    
    /// Default initializer is internal.
    public init()  {
    }

}


/**
 A condition-assertion rule asserts that the input is valid, provided that the condition is true (*the rule matches*).
 If the condition is false, the assertion is not evaluated.
*/
public class ConditionAssertionRule<A: Expression, B: Expression>: Rule where A.Eval == Bool, B.Eval == Bool {
    
    // Assertion of the rule.
    private let assertion: B

    // Condition of the rule.
    private let condition: A
    
    /// Name of the rule.
    public let name: String
    
    /// Initializes the rule.
    public init(name: String, condition: A, assertion: B) {
        self.name = name
        self.condition = condition
        self.assertion = assertion
    }
    
    /// Evaluates the rule in given context, according to the following strategy:
    /// * If the rule matches, answer the result of evaluating the assertion.
    /// * Return nil otherwise.
    public override func eval<C>(in context: C, statistics: inout Statistics) throws -> Bool? {
        guard try condition.eval(in: context) else { return nil }
        
        statistics.matchedRules += 1
        
        return try assertion.eval(in: context)
    }

}


/**
 A rule set contains zero or more rules.
 A rule set has a condition that must be true (*the rule set matches*), If false, the rules in the set are ignored.
 As rule sets subclass Rule, rule sets may be nested.
*/
public class RuleSet<A: Expression>: Rule where A.Eval == Bool {
    
    // Condition of the rule set.
    private let condition: A
    
    // Ordered set of rules.
    private let rules: [Rule]
    
    // If *matchAll* is true (default), evaluation returns the AND-combination of the results of all matching rules.
    // Otherwise, evaluation returns the result of the first matching rule.
    private let matchAll: Bool
    
    /// Name of the rule set.
    public let name: String
    
    /// Initializes the rule set.
    public init(name: String, condition: A, rules: [Rule], matchAll: Bool = true) {
        self.name = name
        self.condition = condition
        self.rules = rules
        self.matchAll = matchAll
    }
    
    /// Evaluates the rule set in given context, according to the following strategy:
    /// * If the rule set does not match or if no rule matches return nil.
    /// * If *matchAll* is true (default), return the AND-combination of the results of all matching rules.
    /// * Otherwise, return the result of the first matching rule.
    public override func eval<C>(in context: C, statistics: inout Statistics) throws -> Bool? {
        guard try condition.eval(in: context) else { return nil }
        let matchedRules = statistics.matchedRules
        
        for rule in rules {
            if let eval = try rule.eval(in: context, statistics: &statistics) {
                guard matchAll, eval else { return eval }
            }
        }
        
        return statistics.matchedRules > matchedRules ? true : nil
    }

}
