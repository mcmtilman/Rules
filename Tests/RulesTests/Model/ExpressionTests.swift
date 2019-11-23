//
//  ExpressionTests.swift
//
//  Created by Michel Tilman on 23/11/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

import XCTest
@testable import Rules

final class ExpressionTests: XCTestCase {
    
    // Test if evaluating a String keypath in an Int context throws an invalidContext error.
    func testEvalInvalidContext() {
        let expression = \String.self
        
        XCTAssertThrowsError(try expression.eval(1)) { error in
            XCTAssertEqual(error as? EvalError, EvalError.invalidContext(message: "Context of type String expected"))
        }
    }

    // Test if evaluating a String keypath in a String context does not throw an invalidContext error.
    func testEvalValidContext() {
        let expression = \String.self
        
        XCTAssertEqual(try expression.eval("A valid context"), "A valid context")
    }

    static var allTests = [
        ("testEvalInvalidContext", testEvalInvalidContext),
        ("testEvalValidContext", testEvalValidContext),
    ]
    
}
