//
//  PredicatesTests.swift
//  Rules
//
//  Created by Michel Tilman on 24/11/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

import XCTest
import Rules


/**
 Tests standard predicates.
 */
class PredicateTests: XCTestCase {
    
    // Test if we can detect nil values.
    func testEvalIsNil() {
        let context: String? = nil
        let keyPath = \String?.self

        XCTAssertTrue(try IsNil(keyPath).eval(context))
    }

    // Test if we can detect non-nil values.
    func testEvalIsNotNil() {
        let context: String? = "String context"
        let keyPath = \String?.self

        XCTAssertFalse(try IsNil(keyPath).eval(context))
    }

}


/**
 Standard predicates.
 */
extension PredicateTests {
    
    typealias IsNil = Predicates.IsNil

}


/**
 Test suite.
 */
extension PredicateTests {
    
    static var allTests = [
        ("testEvalIsNil", testEvalIsNil),
        ("testEvalIsNotNil", testEvalIsNotNil),
    ]

}
