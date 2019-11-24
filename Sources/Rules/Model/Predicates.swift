//
//  Expressions.swift
//  Rules
//
//  Created by Michel Tilman on 23/11/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

/**
 Predicates.
 */
public enum Predicates {

    // MARK: Logical predicates
    
    /// Binary AND operation. The operands evaluate to a boolean value
    public final class And<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval == Bool, B.Eval == Bool {

        /// Returns the AND combination of the evaluated operands.
        /// Operands are evaluated left to right when needed (shortcut evaluation).
        public func eval<C>(_ context: C) throws -> Bool {
            try lhs.eval(context) && rhs.eval(context)
        }

    }

    /// Binary OR operation. The operands must evaluate to a boolean value.
    public final class Or<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval == Bool, B.Eval == Bool {

        /// Returns the OR combination of the evaluated operands.
        /// Operands are evaluated left to right when needed (shortcut evaluation).
        public func eval<C>(_ context: C) throws -> Bool {
            try lhs.eval(context) || rhs.eval(context)
        }

    }
    
    /// Unary NOT operation. The operand must evaluate to a boolean value.
    public final class Not<A: Expression>: UnaryOperation<A> where A.Eval == Bool {

        /// Returns the negation of the evaluated operand.
        public func eval<C>(_ context: C) throws -> Bool {
            try !operand.eval(context)
        }

    }
    
    // MARK: Comparison predicates

    /// Compares ( `==` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class Equal<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the evaluation results of two operands are equal, false otherwise.
        public func eval<C>(_ context: C) throws -> Bool {
            try lhs.eval(context) == rhs.eval(context)
        }

    }

    /// Compares ( `!=` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class NotEqual<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the evaluation results of two operands are not equal, false otherwise.
        public func eval<C>(_ context: C) throws -> Bool {
            try lhs.eval(context) != rhs.eval(context)
        }

    }

    /// Compares ( `>` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class GreaterThan<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the left operand evaluation result is strict greater than the right operand evaluation result, false otherwise.
        public func eval<C>(_ context: C) throws -> Bool {
            try lhs.eval(context) > rhs.eval(context)
        }

    }

    /// Compares ( `>=` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class GreaterThanOrEqual<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the left operand evaluation result is greater than or equal to the right operand evaluation result, false otherwise.
        public func eval<C>(_ context: C) throws -> Bool {
            try lhs.eval(context) >= rhs.eval(context)
        }

    }

    /// Compares ( `<` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class LessThan<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the left operand evaluation result is strict less than the right operand evaluation result, false otherwise.
        public func eval<C>(_ context: C) throws -> Bool {
            try lhs.eval(context) < rhs.eval(context)
        }

    }

    /// Compares ( `<=` ) the evaluation results of two operands.
    /// The operands evaluate to the same comparable type.
    public final class LessThanOrEqual<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval: Comparable, A.Eval == B.Eval {

        /// Returns true if the left operand evaluation result is less than or equal to the right operand evaluation result, false otherwise.
        public func eval<C>(_ context: C) throws -> Bool {
            try lhs.eval(context) <= rhs.eval(context)
        }

    }


    // MARK: Collection predicates

    public final class Contains<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval: Collection, A.Eval.Element == B.Eval, B.Eval: Hashable {

        public func eval<C>(_ context: C) throws -> Bool {
            print(try lhs.eval(context), try rhs.eval(context))
            return try lhs.eval(context).contains(try rhs.eval(context))
        }

    }

    public final class ContainsAll<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval: Collection, B.Eval: Collection, A.Eval.Element == B.Eval.Element, A.Eval.Element: Hashable {

        public func eval<C>(_ context: C) throws -> Bool {
            try Set(lhs.eval(context)).isSuperset(of: try rhs.eval(context))
        }

    }

    public final class ContainsAny<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval: Collection, B.Eval: Collection, A.Eval.Element == B.Eval.Element, A.Eval.Element: Hashable {

        public func eval<C>(_ context: C) throws -> Bool {
            try !Set(lhs.eval(context)).isDisjoint(with: try rhs.eval(context))
        }

    }

    public final class ContainsNone<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval: Collection, B.Eval: Collection, A.Eval.Element == B.Eval.Element, A.Eval.Element: Hashable {

        public func eval<C>(_ context: C) throws -> Bool {
            try Set(lhs.eval(context)).isDisjoint(with: try rhs.eval(context))
        }

    }

    public final class Empty<A: Expression>: UnaryOperation<A> where A.Eval: Collection {

        public func eval<C>(_ context: C) throws -> Bool {
            try operand.eval(context).isEmpty
        }

    }


    // MARK: String predicates

    public final class EndsWith<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval == String, B.Eval == String {

        public func eval<C>(_ context: C) throws -> Bool {
            try lhs.eval(context).hasSuffix(try rhs.eval(context))
        }

    }

    public final class StartsWith<A: Expression, B: Expression>: BinaryOperation<A, B> where A.Eval == String, B.Eval == String {

        public func eval<C>(_ context: C) throws -> Bool {
            try lhs.eval(context).hasPrefix(try rhs.eval(context))
        }

    }

    // MARK: Optional predicates
    
    public final class IsNil<A: Expression, B>: UnaryOperation<A> where A.Eval == Optional<B> {
        
        public func eval<C>(_ context: C) throws -> Bool {
            try operand.eval(context) == nil
        }

    }

}
