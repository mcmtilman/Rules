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
    
    // MARK: Testing single-key paths
    
    // Test accessing an existing single-key path with a non-optional value type.
    func testNonOptionalSingleKeyPath() {
        guard let keyPath: KeyPath<X, Int> = X.keyPath(for: ["x"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.x)
    }
    
    // Test accessing an existing single-key path with an optional value type.
    func testOptionalSingleKeyPath() {
        guard let keyPath: KeyPath<Z?, Int?> = Z?.keyPath(for: ["v"]) else { return XCTFail("Nil key path") }

        XCTAssertEqual(keyPath, \Z?.?.v)
    }
    
    // Test accessing a non-existing single-key key path.
    func testUnknownSingleKeyPath() {
        let keyPath: KeyPath<X, Any>? = X.keyPath(for: ["abc"])
        
        XCTAssertNil(keyPath)
    }
    
    // MARK: Testing multi-key paths
    
    // Test accessing a multi-key path containing no optional value types.
    func testNonOptionalMultiKeyPath() {
        guard let keyPath: KeyPath<X, Int> = X.keyPath(for: ["y", "y"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.y.y)
    }
    
    // Test accessing a multi-key path ending with an optional value type.
    func testMultiKeyPathEndingWithOptional() {
        guard let keyPath: KeyPath<X, Z?> = X.keyPath(for: ["y", "z"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.y.z)
    }
    
    // Test accessing a multi-key path containing an optional value type in the middle.
    func testMultiKeyPathContainingOptional() {
        guard let keyPath: KeyPath<X, Int?> = X.keyPath(for: ["y", "z", "v"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.y.z?.v)
    }

    // Test accessing a non-existing multi-key key path.
    func testUnknownMultiKeyPath() {
        let keyPath: KeyPath<X, Any>? = X.keyPath(for: ["y", "abc"])
        
        XCTAssertNil(keyPath)
    }
    
    // Test accessing and evaluating a multi-key path containing an optional value type followed by multiple non-optional value types.
    // The constructed key path seems to behave as \X.y.z?.zd.a, but is not the same key path. It is not clear if and how \X.y.z?.zd.a
    // can be constructed programmatically.
    func testOptionalChaining() {
        guard let keyPath: KeyPath<X, Int?> = X.keyPath(for: ["y", "z", "zd", "a"]) else { return XCTFail("Nil key path") }
        let context = X(x: 1, y: Y(y: 3, z: Z(v: 5, w: [1, 2, 3], zd: ZD(a: 10))))
        
        XCTAssertEqual(keyPath, (\X.y.z).appending(path: \Z?.?.zd).appending(path: \ZD?.?.a))
        XCTAssertEqual(keyPath, (\X.y.z?.zd).appending(path: \ZD?.?.a))
        XCTAssertNotEqual(keyPath, \X.y.z?.zd.a)
        XCTAssertEqual(context[keyPath: keyPath], 10)
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
        "zd": \Self.zd,
    ]
    
    static let optionalKeyPaths: [String: AnyKeyPath] = [
        "v": \Self?.?.v,
        "w": \Self?.?.w,
        "zd": \Self?.?.zd,
    ]

    let v: Int
    let w: [Int]
    let zd: ZD

}

fileprivate struct ZD: Contextual {
    
    static let keyPaths: [String: AnyKeyPath] = [
        "a": \Self.a,
    ]
    
    static let optionalKeyPaths: [String: AnyKeyPath] = [
        "a": \Self?.?.a,
    ]

    let a: Int

}


/**
 Test suite.
 */
extension ContextTests {
    
    static var allTests = [
        ("testNonOptionalSingleKeyPath", testNonOptionalSingleKeyPath),
        ("testOptionalSingleKeyPath", testOptionalSingleKeyPath),
        ("testUnknownSingleKeyPath", testUnknownSingleKeyPath),
        ("testNonOptionalMultiKeyPath", testNonOptionalMultiKeyPath),
        ("testMultiKeyPathEndingWithOptional", testMultiKeyPathEndingWithOptional),
        ("testMultiKeyPathContainingOptional", testMultiKeyPathContainingOptional),
        ("testUnknownMultiKeyPath", testUnknownMultiKeyPath),
        ("testOptionalChaining", testOptionalChaining),
    ]

}
