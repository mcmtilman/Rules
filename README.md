# Rules

This Swift project is inspired by previous designs of rule engines in Java. Those engines were driven to a greater or lesser extent by the *Dynamic Object Model* pattern.

The goal of this project is to design a rule model that relies as much as possible on the Swift (static) type system.

## Status: In progress

# Expression model

## Core expression model

## Predicates

## Functions

## Context model

Expressions are evaluated in a certain context. To allow expressions to access data in the context, key paths can be used because type *KeyPath* adopts the expression protocol.

The core expression model does not impose any specific requirement on the context types. Evaluating a key path in a given context checks if the context type and the key path's root type are compatible. If not, an *invalidContext* error is thrown.

### Dynamically constructed key paths

Evaluating key paths is a run-time operation. Constructing key paths involves a compile-time step. This makes it difficult to create e.g. an expression builder allowing users to create expressions involving type-safe access to nested properties in the context. (The expression builder must also guarantee that the key path's value type is compatible with the containing expression.)

The *Contextual* protocol allows context types to specify building blocks of 'elementary' key paths, out of which more complex key paths can be constructed dynamically in a type-safe way.

# Rule model

# Engine

# Rule DSL and function builders

# Requirements

The code has been tested with the Swift 5.1 and XCode 11.2.1.
