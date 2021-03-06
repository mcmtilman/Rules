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
    
    // MARK: Testing failable array subscripts
    
    func testInRangeArrayKeyPath() {
        let keyPath = \[Int][failable: 1]
        let context = [1, 2]
        
        XCTAssertEqual(context[keyPath: keyPath], 2)
    }
    
    func testOutOfRangeArrayKeyPath() {
        let keyPath = \[Int][failable: 2]
        let context = [1, 2]
        
        XCTAssertNil(context[keyPath: keyPath])
    }
    
    // MARK: Testing known paths
    
    // Test accessing a known key path with non-optional value type.
    func testKnownKeyPath() {
        guard let keyPath = X.keyPath(for: "x") else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.x)
    }
    
    // Test accessing a known key path with optional value type.
    func testKnownOptionalKeyPath() {
        guard let keyPath = Z?.keyPath(for: "v") else { return XCTFail("Nil key path") }

        XCTAssertEqual(keyPath, \Z?.?.v)
    }
    
    // Test accessing an unknown key path.
    func testUnknownKeyPath() {
        let keyPath = X.keyPath(for: "abc")
        
        XCTAssertNil(keyPath)
    }
    
    // MARK: Testing known array paths

    // Test accessing a known key path for an array.
    func testKnownArrayKeyPath() {
        guard let keyPath = [Int].keyPath(for: "1") else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \[Int][failable: 1])
    }
    
    // Test accessing a unknown key path for an array.
    func testUnknownArrayKeyPath() {
        let keyPath = [Int].keyPath(for: "abc")
        
        XCTAssertNil(keyPath)
    }
    
    // MARK: Testing known dictionary paths

    // Test accessing a known key path for a dictionary.
    func testKnownDictionaryKeyPath() {
        guard let keyPath = [String: Int].keyPath(for: "a") else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \[String: Int]["a"])
    }
    
    // Test accessing a known key path for an optional dictionary.
    func testKnownOptionalDictionaryKeyPath() {
        guard let keyPath = [String: Int]?.keyPath(for: "a") else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \[String: Int]?.?["a"])
    }
    
    // MARK: Testing constructing key paths
    
    // Test if 'constructing' a known key path is similar as directly accessing the key path.
    func testConstructKnownKeyPath() {
        guard let keyPath: KeyPath<X, Int> = X.keyPath(for: ["x"]) else { return XCTFail("Nil key path") }

        XCTAssertEqual(keyPath, X.keyPath(for: "x"))
    }
    
    // Test constructing a key path for a nested non-optional property.
    func testConstructNonOptionalKeyPath() {
        guard let keyPath: KeyPath<X, Int> = X.keyPath(for: ["y", "y"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.y.y)
    }
    
    // Test constructing a key path for a nested optional property.
    func testConstructKeyPathEndingWithOptional() {
        guard let keyPath: KeyPath<X, Z?> = X.keyPath(for: ["y", "z"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.y.z)
    }
    
    // Test constructing a key path for a nested optional property followed by one non-optional property.
    func testConstructKeyPathContainingOptional() {
        guard let keyPath: KeyPath<X, Int?> = X.keyPath(for: ["y", "z", "v"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.y.z?.v)
    }

    // Test accessing a non-existing multi-key key path.
    func testConstructInvalidKeyPath() {
        let keyPath: KeyPath<X, Any>? = X.keyPath(for: ["y", "abc"])
        
        XCTAssertNil(keyPath)
    }
    
    // Test accessing a multi-key path containing an optional property followed by two non-optional properties as one key path,
    // i.e. the two final non-optional properties are appended in one go.
    // The constructed key path is the same as \X.y.z?.zd.a.
    func testOptionalChaining() {
        guard let keyPath: KeyPath<X, Int?> = X.keyPath(for: ["y", "z", "zda"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.y.z?.zd.a)
    }

    // Test constructing a key path for a nested optional property followed by two non-optional properties.
    // The constructed key path seems to behave as \X.y.z?.zd.a, but is not the same key path.
    // It is not clear if and how \X.y.z?.zd.a can be constructed programmatically.
    func testSimulateOptionalChaining() {
        guard let keyPath: KeyPath<X, Int?> = X.keyPath(for: ["y", "z", "zd", "a"]) else { return XCTFail("Nil key path") }
        let fullContext = X(x: 1, y: Y(y: 3, z: Z(v: 5, w: [1, 2, 3], zd: ZD(a: 10)), d: [:], e: [:], f:[], g:[]))
        let partialContext = X(x: 1, y: Y(y: 3, z: nil, d: [:], e: [:], f:[], g:[]))

        XCTAssertEqual(keyPath, (\X.y.z).appending(path: \Z?.?.zd).appending(path: \ZD?.?.a))
        XCTAssertEqual(keyPath, (\X.y.z?.zd).appending(path: \ZD?.?.a))
        XCTAssertNotEqual(keyPath, \X.y.z?.zd.a)
        XCTAssertEqual(fullContext[keyPath: keyPath], 10)
        XCTAssertNil(partialContext[keyPath: keyPath])
    }

    // Test constructing a key path for a key in a nested dictionary.
    func testConstructDictionaryKeyPath() {
        guard let keyPath: KeyPath<X, Int?> = X.keyPath(for: ["y", "d", "a"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.y.d["a"])
    }

    // Test constructing a key path for a key in a nested optional dictionary.
    func testConstructOptionalDictionaryKeyPath() {
        guard let keyPath: KeyPath<X, Int?> = X.keyPath(for: ["y", "e", "a"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.y.e?["a"])
    }

    // Test constructing a key path for an index in a nested array.
    func testConstructArrayKeyPath() {
        guard let keyPath: KeyPath<X, Int?> = X.keyPath(for: ["y", "f", "0"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.y.f[failable: 0])
    }

    // Test constructing a key path for an index in a nested optional array.
    func testConstructOptionalArrayKeyPath() {
        guard let keyPath: KeyPath<X, Int?> = X.keyPath(for: ["y", "g", "0"]) else { return XCTFail("Nil key path") }
        
        XCTAssertEqual(keyPath, \X.y.g?[failable: 0])
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
        "d": \Self.d,
        "e": \Self.e,
        "f": \Self.f,
        "g": \Self.g,
    ]

    let y: Int
    let z: Z?
    let d: [String: Int]
    let e: [String: Int]?
    let f: [Int]
    let g: [Int]?

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
        "zda": \Self?.?.zd.a,
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
