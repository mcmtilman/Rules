//
//  Operations.swift
//  Rules
//
//  Created by Michel Tilman on 28/11/2019.
//

/**
 'Abstract' superclass representing state and initialization of operations involving one operand.
 */
open class UnaryOperation<A> {
    
    /// The single operand.
    public let operand: A
    
    /// Initializes the operand.
    public init(_ operand: A) {
        self.operand = operand
    }
    
}


/**
 'Abstract' superclass representing state and initialization of operations involving two operands.
 */
open class BinaryOperation<A, B> {
    
    /// Left- and right-hand-side operands.
    public let lhs: A, rhs: B
    
    /// Initializes the left- and right-hand-side operands.
    public init(_ lhs: A, _ rhs: B) {
        self.lhs = lhs
        self.rhs = rhs
    }
    
}
