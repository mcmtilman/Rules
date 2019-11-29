//
//  Expressions.swift
//  Rules
//
//  Created by Michel Tilman on 23/11/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

import Foundation

/**
 Predicates.
 */
public enum Predicate {

    // MARK: Logical predicates
    
    /// Binary AND operation. The operands evaluate to a boolean value
    public final class And<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval == Bool, B.Eval == Bool {

        /// Returns the AND combination of the evaluated operands.
        /// Operands are evaluated left to right when needed (shortcut evaluation).
        public func eval<C>(in context: C) throws -> Bool {
            try lhs.eval(in: context) && rhs.eval(in: context)
        }

    }

    /// Binary OR operation. The operands must evaluate to a boolean value.
    public final class Or<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval == Bool, B.Eval == Bool {

        /// Returns the OR combination of the evaluated operands.
        /// Operands are evaluated left to right when needed (shortcut evaluation).
        public func eval<C>(in context: C) throws -> Bool {
            try lhs.eval(in: context) || rhs.eval(in: context)
        }

    }
    
    /// Unary NOT operation. The operand must evaluate to a boolean value.
    public final class Not<A: Expression>: UnaryOperation<A>, Expression where A.Eval == Bool {

        /// Returns the negation of the evaluated operand.
        public func eval<C>(in context: C) throws -> Bool {
            try !operand.eval(in: context)
        }

    }
    
    // MARK: Collection predicates

    public final class Contains<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval: Collection, A.Eval.Element == B.Eval, B.Eval: Hashable {

        public func eval<C>(in context: C) throws -> Bool {
            try lhs.eval(in: context).contains(try rhs.eval(in: context))
        }

    }

    public final class ContainsNot<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval: Collection, A.Eval.Element == B.Eval, B.Eval: Hashable {

        public func eval<C>(in context: C) throws -> Bool {
            !(try lhs.eval(in: context).contains(try rhs.eval(in: context)))
        }

    }

    public final class ContainsAll<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval: Collection, B.Eval: Collection, A.Eval.Element == B.Eval.Element, A.Eval.Element: Hashable {

        public func eval<C>(in context: C) throws -> Bool {
            try Set(lhs.eval(in: context)).isSuperset(of: try rhs.eval(in: context))
        }

    }

    public final class ContainsAny<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval: Collection, B.Eval: Collection, A.Eval.Element == B.Eval.Element, A.Eval.Element: Hashable {

        public func eval<C>(in context: C) throws -> Bool {
            try !Set(lhs.eval(in: context)).isDisjoint(with: try rhs.eval(in: context))
        }

    }

    public final class ContainsNone<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval: Collection, B.Eval: Collection, A.Eval.Element == B.Eval.Element, A.Eval.Element: Hashable {

        public func eval<C>(in context: C) throws -> Bool {
            try Set(lhs.eval(in: context)).isDisjoint(with: try rhs.eval(in: context))
        }

    }

    public final class IsEmpty<A: Expression>: UnaryOperation<A>, Expression where A.Eval: Collection {

        public func eval<C>(in context: C) throws -> Bool {
            try operand.eval(in: context).isEmpty
        }

    }

    public final class IsNotEmpty<A: Expression>: UnaryOperation<A>, Expression where A.Eval: Collection {

        public func eval<C>(in context: C) throws -> Bool {
            try !operand.eval(in: context).isEmpty
        }

    }

    // MARK: Comparison predicates

    /// Compares ( `==` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class IsEqual<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the evaluation results of two operands are equal, false otherwise.
        public func eval<C>(in context: C) throws -> Bool {
            try lhs.eval(in: context) == rhs.eval(in: context)
        }

    }

    /// Compares ( `!=` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class IsNotEqual<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the evaluation results of two operands are not equal, false otherwise.
        public func eval<C>(in context: C) throws -> Bool {
            try lhs.eval(in: context) != rhs.eval(in: context)
        }

    }

    /// Compares ( `>` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class IsGreaterThan<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the left operand evaluation result is strict greater than the right operand evaluation result, false otherwise.
        public func eval<C>(in context: C) throws -> Bool {
            try lhs.eval(in: context) > rhs.eval(in: context)
        }

    }

    /// Compares ( `>=` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class IsGreaterThanOrEqual<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the left operand evaluation result is greater than or equal to the right operand evaluation result, false otherwise.
        public func eval<C>(in context: C) throws -> Bool {
            try lhs.eval(in: context) >= rhs.eval(in: context)
        }

    }

    /// Compares ( `<` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class IsLessThan<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the left operand evaluation result is strict less than the right operand evaluation result, false otherwise.
        public func eval<C>(in context: C) throws -> Bool {
            try lhs.eval(in: context) < rhs.eval(in: context)
        }

    }

    /// Compares ( `<=` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class IsLessThanOrEqual<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the left operand evaluation result is less than or equal to the right operand evaluation result, false otherwise.
        public func eval<C>(in context: C) throws -> Bool {
            try lhs.eval(in: context) <= rhs.eval(in: context)
        }

    }

    // MARK: String predicates

    /// Both operands evaluate to strings.
    /// Tests if the left string is a prefix of the right string.
    public final class IsPrefix<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval == String, B.Eval == String {

        /// Returns true if the left string is a prefix of the right string, false otherwise.
        public func eval<C>(in context: C) throws -> Bool {
            try rhs.eval(in: context).hasPrefix(try lhs.eval(in: context))
        }

    }

    /// Both operands evaluate to strings.
    /// Tests if the left string is a substring of the right string.
    public final class IsSubstring<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval == String, B.Eval == String {

        /// Returns true if the left string is a substring of the right string, false otherwise.
        public func eval<C>(in context: C) throws -> Bool {
            try rhs.eval(in: context).contains(try lhs.eval(in: context))
        }

    }

    /// Both operands evaluate to strings.
    /// Tests if the left string is a suffix of the right string.
    public final class IsSuffix<A: Expression, B: Expression>: BinaryOperation<A, B>, Expression where A.Eval == String, B.Eval == String {

        /// Returns true if the right string is a suffix of the left string, false otherwise.
        public func eval<C>(in context: C) throws -> Bool {
            try rhs.eval(in: context).hasSuffix(try lhs.eval(in: context))
        }

    }

    // MARK: Optional predicates
    
    public final class IsNil<A: Expression, B>: UnaryOperation<A>, Expression where A.Eval == Optional<B> {
        
        public func eval<C>(in context: C) throws -> Bool {
            try operand.eval(in: context) == nil
        }

    }

    public final class IsNotNil<A: Expression, B>: UnaryOperation<A>, Expression where A.Eval == Optional<B> {
        
        public func eval<C>(in context: C) throws -> Bool {
            try operand.eval(in: context) != nil
        }

    }

}
