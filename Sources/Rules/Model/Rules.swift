//
//  Rules.swift
//  Rules
//
//  Created by Michel Tilman on 23/11/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

public protocol Rule: Expression {}

/**
 A condition-assertion rule asserts that the input is valid, provided that the condition holds.
 If the condition is false, the assertion is ignored.
*/
public class ConditionAssertionRule<A: Expression, B: Expression>: BinaryOperation<A, B>, Rule where A.Eval == Bool, B.Eval == Bool {
    
    /// Returns the result of the assertion if the condition is true, or nil otherwise.
    public func eval<C>(in context: C) throws -> Bool? {
        try lhs.eval(in: context) ? try rhs.eval(in: context) : nil
    }

}
