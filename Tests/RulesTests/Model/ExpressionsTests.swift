//
//  ExpressionsTests.swift
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
class ExpressionsTests: XCTestCase {
    
    // MARK: Testing context
    
    ///// Test if evaluating a String keypath in an Int context throws an invalidContext error.
    func testEvalInvalidContext() {
        let context: String? = nil
        let keyPath = \String.self
        
        XCTAssertThrowsError(try keyPath.eval(context)) { error in
            XCTAssertEqual(error as? EvalError, EvalError.invalidContext(message: "Context of type String expected"))
        }
    }

    // Test if evaluating a String keypath in a nil context throws an invalidContext error.
    func testEvalNilContext() {
        let context: String? = nil
        let keyPath = \String.self
        
        XCTAssertThrowsError(try keyPath.eval(context)) { error in
            XCTAssertEqual(error as? EvalError, EvalError.invalidContext(message: "Context of type String expected"))
        }
    }

    // Test if evaluating a String keypath in a String context does not throw an invalidContext error.
    func testEvalValidContext() {
        let context = "String context"
        let keyPath = \String.self

        XCTAssertEqual(try keyPath.eval(context), "String context")
    }
    
}


/**
 Test suite.
 */
extension ExpressionsTests {
    
    static var allTests = [
        ("testEvalInvalidContext", testEvalInvalidContext),
        ("testEvalNilContext", testEvalNilContext),
        ("testEvalValidContext", testEvalValidContext),
    ]

}
