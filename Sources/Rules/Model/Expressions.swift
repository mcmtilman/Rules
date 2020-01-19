//
//  Expressions.swift
//  Rules
//
//  Created by Michel Tilman on 23/11/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

/**
 Expressions are the building blocks of rules.
 */
public protocol Expression {
    
    /// The evaluation result of an expression.
    ///
    /// If the expression is nested, this type must match the requirements of parent expression.
    /// For instance, an *And* operator expects two Boolean operands: expressions having Eval == Bool.
    associatedtype Eval
    
    /// Evaluates the expression in given context and returns the result.
    func eval<C>(in context: C) throws -> Eval
    
}


/**
 Default expression evaluation.
 */
public extension Expression {
    
    /// By default an expression evaluates to self.
    func eval<C>(in context: C) throws -> Self {
        self
    }

}


/**
 Evaluation errors.
 */
public enum EvalError: Error, Equatable {
    
    /// Error thrown when evaluating an expression in the wrong context type.
    case invalidContext(message: String)

}


/**
 These basic types can be used as expressions, using the default eval.
 */
extension Bool: Expression {}
extension Double: Expression {}
extension Int: Expression {}
extension String: Expression {}


/**
 Arrays of expressions can be used as expressions.
 */
extension Array: Expression where Element: Expression {
   
    /// Evaluation returns an array consisting of the evaluations of all the elements.
    public func eval<C>(in context: C) throws -> [Element.Eval] {
        try map { try $0.eval(in: context) }
    }
   
}


/**
 Keypaths can be used as expressions.
 */
extension KeyPath: Expression {
     
    /// Returns the value of the key path from given root context.
    ///
    /// Conformance of the context type with the keypath's root type is  checked at run-time.
    /// Failure to comply results in an *invalidContext* error.
    public func eval<C>(in context: C) throws -> Value {
        guard let root = context as? Root else { throw EvalError.invalidContext(message: "Context of type \(Root.self) expected") }

        return root[keyPath: self]
    }

 }
