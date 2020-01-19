//
//  FunctionTests.swift
//  Rules
//
//  Created by Michel Tilman on 24/11/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

import XCTest
import Rules

/**
 Tests standard functions.
 */
class FunctionTests: XCTestCase {
    
    // MARK: Testing optionals
    
    // Test default value for expression evaluating to nil.
    func testEvalIfNil() {
        let context: String? = nil
        let keyPath = \String?.self
        
        XCTAssertEqual(try IfNil(keyPath, "Default string").eval(in: context), "Default string")
    }

    // Test value for expression evaluating to a non-nil value.
    func testEvalIfNotNil() {
        let context: String? = "String context"
        let keyPath = \String?.self
        
        XCTAssertEqual(try IfNil(keyPath, "Default string").eval(in: context), "String context")
    }

    // MARK: Testing strings
    
    // Test length function.
    func testEvalLength() {
        let string = "The quick brown fox jumps over the lazy dog."
        
        XCTAssertEqual(try Length(string).eval(in: ()), 44)
    }

    // Test lowercase function.
    func testEvalLowercase() {
        let string = "MixedCase"
        
        XCTAssertEqual(try Lowercase(string).eval(in: ()), "mixedcase")
    }

    // Test uppercase function.
    func testEvalUppercase() {
        let string = "MixedCase"

        XCTAssertEqual(try Uppercase(string).eval(in: ()), "MIXEDCASE")
    }
    
}


/**
 Standard functions.
 */
extension FunctionTests {
    
    typealias IfNil = Function.IfNil
    typealias Length = Function.Length
    typealias Lowercase = Function.Lowercase
    typealias Uppercase = Function.Uppercase

}


/**
 Function test suite.
 */
extension FunctionTests {
    
    static var allTests = [
        ("testEvalIfNil", testEvalIfNil),
        ("testEvalIfNotNil", testEvalIfNotNil),
        ("testEvalLength", testEvalLength),
        ("testEvalLowercase", testEvalLowercase),
        ("testEvalUppercase", testEvalUppercase),
    ]
    
}
