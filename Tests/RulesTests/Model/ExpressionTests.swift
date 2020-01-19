//
//  ExpressionTests.swift
//  Rules
//
//  Created by Michel Tilman on 23/11/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

import XCTest
import Rules

/**
 Tests core expressions.
 */
class ExpressionTests: XCTestCase {
    
    // MARK: Testing context
    
    // Test if evaluating a String key path in an Int context throws an invalidContext error.
    func testEvalInvalidContext() {
        let context = 0
        let keyPath = \String.self
        
        XCTAssertThrowsError(try keyPath.eval(in: context)) { error in
            XCTAssertEqual(error as? EvalError, EvalError.invalidContext(message: "Context of type String expected"))
        }
    }

    // Test if evaluating a String key path in a nil context throws an invalidContext error.
    func testEvalNilContext() {
        let context: String? = nil
        let keyPath = \String.self

        XCTAssertThrowsError(try keyPath.eval(in: context)) { error in
            XCTAssertEqual(error as? EvalError, EvalError.invalidContext(message: "Context of type String expected"))
        }
    }

    // Test if evaluating a key path in a subclass context does not throw an invalidContext error.
    func testEvalSubclassContext() {
        class A { let a = 1 }
        class B: A {}
        
        let context = B()
        let keyPath = \A.a

        XCTAssertEqual(try keyPath.eval(in: context), 1)
    }
    
    // Test if evaluating a String key path in a String context does not throw an invalidContext error.
    func testEvalValidContext() {
        let context = "String context"
        let keyPath = \String.self

        XCTAssertEqual(try keyPath.eval(in: context), "String context")
    }
    
    // Test evaluating a nested key path.
    func testEvalNestedKeyPath() {
        struct X {
            struct Y {
                let y = ["a": [10, 20], "b": [30, 40, 50]]
            }
            let x = Y()
        }
        let context = X()
        let keyPath = \X.x.y["b"]?[1]

        XCTAssertEqual(try keyPath.eval(in: context), 40)
    }
    
}


/**
 Expression test suite.
 */
extension ExpressionTests {
    
    static var allTests = [
        ("testEvalInvalidContext", testEvalInvalidContext),
        ("testEvalNilContext", testEvalNilContext),
        ("testEvalSubclassContext", testEvalSubclassContext),
        ("testEvalValidContext", testEvalValidContext),
        ("testEvalNestedKeyPath", testEvalNestedKeyPath),
    ]

}
