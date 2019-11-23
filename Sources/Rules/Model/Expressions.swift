//
//  Expressions.swift
//
//  Created by Michel Tilman on 23/11/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

/**
 Expressions are the building blocks of rules.
 */
public protocol Expression {
    
    /// The evaluation result of an expression. If the expression is nested, this type must match the requirements of parent expression.
    /// For instance, an And operator expects two Boolean sub-expressions, i.e. expressions where Eval == Bool.
    associatedtype Eval
    
    /// Evaluate the expression in given context and answer the result.
    func eval<C>(_ context: C) throws -> Eval
    
}


/**
 Default expression evaluation.
 */
public extension Expression {
    
    /// By default an expression evaluates to self.
    func eval<C>(_ context: C) throws -> Self {
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
   
    /// Evalution returns an array consisting of the evaluations of all the elements.
    public func eval<C>(_ context: C) throws -> [Element.Eval] {
        try map { try $0.eval(context) }
    }
   
}


/**
 Keypaths can be used as expressions.
 */
extension KeyPath: Expression {
     
    /// Conformance of the context type with the keypath's root type is  checked  at run-time.
    /// Failure to comply results in an *invalidContext* error.
    public func eval<C>(_ context: C) throws -> Value {
         guard let context = context as? Root else { throw EvalError.invalidContext(message: "Context of type \(Root.self) expected") }

         return context[keyPath: self]
     }

 }


/**
 'Abstract' superclass representing state and initialization of operations involving one operand.
 Unary operations can be used as expressions.
 */
open class UnaryOperation<A>: Expression {
    
    // The single operand.
    public let operand: A
    
    // Sole initializer.
    public init(_ operand: A) {
        self.operand = operand
    }
    
}


/**
 'Abstract' superclass representing state and initialization of operations involving two operands.
 Binary operations can be used as expressions.
 */
open class BinaryOperation<A, B>: Expression {
    
    // Left- and right-hand-side operands.
    public let lhs: A, rhs: B
    
    // Sole initializer.
    public init(_ lhs: A, _ rhs: B) {
        self.lhs = lhs
        self.rhs = rhs
    }
    
}
