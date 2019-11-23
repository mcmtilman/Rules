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
    
    /// The evaluation result of an expression. If the expression is nested, this type must match the requirements of parent expression.
    /// For instance, an And operator expects two Boolean sub-expressions, i.e. expressions where Eval == Bool.
    associatedtype Eval
    
    /// Evaluate the expression in given context and answer the result.
    func eval<C>(_ context: C) throws -> Eval
    
}

/**
 Default expression evaluation.
 */
extension Expression {
    
    /// By default an expression evaluates to self.
    public func eval<C>(_ context: C) throws -> Self {
        self
    }

}


/**
 Evaluation errors.
 */
public enum EvalError: Error {
    
    /// Error thrown when evaluating an expression in the wrong context type.
    case invalidContext(message: String)

    /// Error thrown when evaluating an expression in the wrong context type.
    case nilValue(message: String)

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
 Using structs for the concrete types requires more code.
 */
public class UnaryOperation<A> {
    
    // The single operand.
    let operand: A
    
    // Sole initializer.
    init(_ operand: A) {
        self.operand = operand
    }
    
}


/**
 'Abstract' superclass representing state and initialization of operations involving two operands.
 Using structs for the concrete types requires more code.
 */
public class BinaryOperation<A, B> {
    
    // Left and right operands.
    let lhs: A, rhs: B
    
    // Sole initializer.
    init(_ lhs: A, _ rhs: B) {
        self.lhs = lhs
        self.rhs = rhs
    }
    
}
