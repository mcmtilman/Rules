//
//  Functions.swift
//  Rules
//
//  Created by Michel Tilman on 23/11/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

/**
 Functions used in predicates.
 */
public enum Function {

    // MARK: Optional value functions

    /// Nil coalescing operator as an expression.
    public final class IfNil<A: Expression, B>: BinaryOperation<A, B>, Expression where A.Eval == Optional<B> {

        /// Returns the evaluation of the expression, unless it is nil, in which case the default value is returned.
        public func eval<C>(in context: C) throws -> B {
            try lhs.eval(in: context) ?? rhs
        }

    }

    // MARK: String functions

    /// Returns the length of a string expression.
    public final class Length<A: Expression>: UnaryOperation<A>, Expression where A.Eval == String {

        /// Returns the length of the evaluation result.
        public func eval<C>(in context: C) throws -> Int {
            try operand.eval(in: context).count
        }

    }

    /// Converts a string expression into a lowercase string.
    public final class Lowercase<A: Expression>: UnaryOperation<A>, Expression where A.Eval == String {

        /// Returns the lowercased evaluation result.
        public func eval<C>(in context: C) throws -> String {
            try operand.eval(in: context).lowercased()
        }

    }

    /// Converts a string expression into an uppercase string.
    public final class Uppercase<A: Expression>: UnaryOperation<A>, Expression where A.Eval == String {

        /// Returns the uppercased evaluation result.
        public func eval<C>(in context: C) throws -> String {
            try operand.eval(in: context).uppercased()
        }

    }
    
}
