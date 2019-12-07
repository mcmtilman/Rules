//
//  ContextTests.swift
//  Rules
//
//  Created by Michel Tilman on 07/12/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

import XCTest
import Rules

/**
 Tests core expressions.
 */
class ContextTests: XCTestCase {
    
    // MARK: Testing basic key paths
    
    // Test accessing and applying an existing basic key path.
    func testBasicKeyPath() {
        guard let keyPath = X.keyPaths["x"] as? KeyPath<X, Int> else { return XCTFail("Nil key path") }
        let context = X(x: 1, y: Y(y: 3, z: Z(v: 5, w: [1, 2, 3])))
        
        XCTAssertEqual(keyPath, \X.x)
        XCTAssertEqual(context[keyPath: keyPath], 1)
    }
    
    // Test accessing a non-existing basic key path.
    func testNilBasicKeyPath() {
        let keyPath = X.keyPaths["abc"]
        
        XCTAssertNil(keyPath)
    }
    
    // Test accessing a existing basic key path for an optional type.
    func testOptionalBasicKeyPath() {
        let keyPath = Z?.keyPaths["v"]
        
        XCTAssertEqual(keyPath, \Z?.?.v)
    }
    
    // MARK: Testing constructing non-optional-chaining key paths
    
    // Test constructing and applying a key path with basic value type.
    func testConstructBasicValueKeyPath() {
        guard let keyPath: KeyPath<X, Int> = X.keyPath(for: ["y", "y"]) else { return XCTFail("Nil key path") }
        let context = X(x: 1, y: Y(y: 3, z: Z(v: 5, w: [1, 2, 3])))
        
        XCTAssertEqual(keyPath, \X.y.y)
        XCTAssertEqual(context[keyPath: keyPath], 3)
    }
    
    // Test constructing and applying a key path with optional value type.
    func testConstructOptionalValueKeyPath() {
        guard let keyPath: KeyPath<X, Z?> = X.keyPath(for: ["y", "z"]) else { return XCTFail("Nil key path") }
        let context = X(x: 1, y: Y(y: 3, z: nil))
        
        XCTAssertEqual(keyPath, \X.y.z)
        XCTAssertNil(context[keyPath: keyPath])
    }
    
}


/**
 Test model.
 */
fileprivate struct X: Contextual {
    
    static let keyPaths: [String: AnyKeyPath] = [
        "x": \Self.x,
        "y": \Self.y,
    ]

    let x: Int
    let y: Y

}

fileprivate struct Y: Contextual {
    
    static let keyPaths: [String: AnyKeyPath] = [
        "y": \Self.y,
        "z": \Self.z,
    ]

    let y: Int
    let z: Z?

}

fileprivate struct Z: Contextual {
    
    static let keyPaths: [String: AnyKeyPath] = [
        "v": \Self.v,
        "w": \Self.w,
    ]
    
    static let optionalKeyPaths: [String: AnyKeyPath] = [
        "v": \Self?.?.v,
        "w": \Self?.?.w,
    ]

    let v: Int
    let w: [Int]

}


/**
 Test suite.
 */
extension ContextTests {
    
    static var allTests = [
        ("testBasicKeyPath", testBasicKeyPath),
        ("testNilBasicKeyPath", testNilBasicKeyPath),
        ("testOptionalBasicKeyPath", testOptionalBasicKeyPath),
        ("testConstructBasicValueKeyPath", testConstructBasicValueKeyPath),
        ("testConstructOptionalValueKeyPath", testConstructOptionalValueKeyPath),
    ]

}
