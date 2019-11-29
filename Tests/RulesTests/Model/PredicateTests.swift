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
    
    // Test if a collection is empty.
    func testEvalIsEmpty() {
        XCTAssertTrue(try IsEmpty([Int]()).eval(in: ()))
        XCTAssertFalse(try IsEmpty([1, 2]).eval(in: ()))
        
        XCTAssertTrue(try IsEmpty("").eval(in: ()))
        XCTAssertFalse(try IsEmpty("not empty").eval(in: ()))
    }

    // Test if a collection is not empty.
    func testEvalIsNotEmpty() {
        XCTAssertFalse(try IsNotEmpty([Int]()).eval(in: ()))
        XCTAssertTrue(try IsNotEmpty([1, 2]).eval(in: ()))

        XCTAssertFalse(try IsNotEmpty("").eval(in: ()))
        XCTAssertTrue(try IsNotEmpty("not empty").eval(in: ()))
    }

    // Test if a value is nil.
    func testEvalIsNil() {
        let keyPath = \String?.self
        
        XCTAssertTrue(try IsNil(keyPath).eval(in: nil as String?))
        XCTAssertFalse(try IsNil(keyPath).eval(in: "not nil"))
    }

    // Test if a value is not nil.
    func testEvalIsNotNil() {
        let keyPath = \String?.self
        
        XCTAssertFalse(try IsNotNil(keyPath).eval(in: nil as String?))
        XCTAssertTrue(try IsNotNil(keyPath).eval(in: "not nil"))
    }

    // Test if we can find a prefix string.
    func testEvalIsPrefix() {
        let string = "abcdef"

        XCTAssertTrue(try IsPrefix("ab", string).eval(in: ()))
        XCTAssertFalse(try IsPrefix("ba", string).eval(in: ()))
    }

    // Test if we can find a substring.
    func testEvalIsSubstring() {
        let string = "abcdef"

        XCTAssertTrue(try IsSubstring("cd", string).eval(in: ()))
        XCTAssertFalse(try IsSubstring("dc", string).eval(in: ()))
    }

    // Test if we can find a suffix string.
    func testEvalIsSuffix() {
        let string = "abcdef"
        
        XCTAssertTrue(try IsSuffix("ef", string).eval(in: ()))
        XCTAssertFalse(try IsSuffix("fe", string).eval(in: ()))
    }

}


/**
 Standard predicates.
 */
extension PredicateTests {
    
    typealias IsEmpty = Predicate.IsEmpty
    typealias IsNotEmpty = Predicate.IsNotEmpty
    typealias IsNil = Predicate.IsNil
    typealias IsNotNil = Predicate.IsNotNil
    typealias IsPrefix = Predicate.IsPrefix
    typealias IsSubstring = Predicate.IsSubstring
    typealias IsSuffix = Predicate.IsSuffix

}


/**
 Test suite.
 */
extension PredicateTests {
    
    static var allTests = [
        ("testEvalIsEmpty", testEvalIsEmpty),
        ("testEvalIsNotEmpty", testEvalIsNotEmpty),
        ("testEvalIsNil", testEvalIsNil),
        ("testEvalIsNotNil", testEvalIsNotNil),
        ("testEvalIsPrefix", testEvalIsPrefix),
        ("testEvalIsSubstring", testEvalIsSubstring),
        ("testEvalIsSuffix", testEvalIsSuffix),
    ]

}
