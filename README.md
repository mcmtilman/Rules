# Rules

This Swift project is inspired by previous designs of rule engines in Java. Those engines were driven to a greater or lesser extent by the *Dynamic Object Model* pattern.

The goal of this project is to design a rule model that relies as much as possible on the Swift (static) type system.

## Status: In progress

# Expression model

Expressions are the building blocks of rules. Expressions may be composed to create e.g. rule predicates.

Example expressions include:
* basic types like *Bool* and *Int*
* arrays consisting of expressions
* key paths
* predicates
* functions.

## Core expression model

Expressions adopt the *Expression* protocol. This protocol requires adopting types to provide an evaluation function:

> func eval<C>(in context: C) throws -> Eval

where Eval is an associated type.

Composition of expressions is based on the Eval return type of the *eval* function rather than on the expression types themselves. Evaluation of a composite expression typically results in a recursive descent evaluation strategy.

The core expression makes few assumptions on the evaluation context, except that key paths used in the expressions must be applicable to the evaluation context.

## Operations

Most predicates provided by default have a limited number of operands. The classes *UnaryOperation* and *BinaryOperation* are just convience classes to re-use the operand properties and initialization.

Use of these classes is not required, however, and neither must predicates be implemented as classes. 

## Predicates

Predicates are either:
* *Bool* values
* composite expressions with boolean *Eval* type.

Default predicates are defined in the *Predicate* enum namespace.

## Functions

Functions allow us to transform expressions into other expressions.

Examples include:
* converting strings into upper- or lower-cased versions
* testing if an optional value is nil.

Default functions are defined in the *Function* enum namespace.

## Context model

Expressions are evaluated in a certain context. To allow expressions to access data in the context, key paths can be used because type *KeyPath* adopts the *Expression* protocol.

The core expression model does not impose any specific requirement on the context types. Evaluating a key path in a given context checks if the context type and the key path's root type are compatible. If not, an *invalidContext* error is thrown.

### Dynamically constructed key paths

Evaluating key paths is a run-time operation. Constructing key paths involves a compile-time step. This makes it difficult to create e.g. an expression builder allowing users to create expressions involving type-safe access to nested properties in the context. (The expression builder must also guarantee that the key path's value type is compatible with the containing expression.)

The *Contextual* protocol allows context types to specify building blocks of 'elementary' key paths, out of which more complex key paths can be constructed dynamically in a type-safe way.

# Rule model

# Engine

# Rule DSL and function builders

# Requirements

The code has been tested with the Swift 5.1 and XCode 11.2.1.
