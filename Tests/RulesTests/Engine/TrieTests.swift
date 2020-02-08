//
//  TrieTests.swift
//  RulesTests
//
//  Created by Michel Tilman on 02/02/2020.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

import XCTest
import Rules

/**
 Tests trie operations.
 */
class TrieTests: XCTestCase {
    
    // MARK: Testing acessing
    
    // Test if accessing an empty trie.
    func testEmptyTrie() {
        let trie = DefaultTrie<String, Int>()
        
        XCTAssertEqual(trie.count, 0)
        XCTAssertNil(trie.getValue(forKeys: ["a"]))
        XCTAssertNil(trie.getBestValue(forKeys: ["a"]))
    }

    // Test trie count.
    func testCount() {
        let trie = DefaultTrie<String, Int>()
         
        XCTAssertEqual(trie.count, 0)
        trie.updateValue(1, forKeys: ["a"])
        XCTAssertEqual(trie.count, 1)
        trie.updateValue(2, forKeys: ["b"])
        XCTAssertEqual(trie.count, 2)
        trie.updateValue(3, forKeys: ["a"])
        XCTAssertEqual(trie.count, 2)
    }

    // Test getting values for key chaina of length 1.
    func testGetValue() {
        let trie = DefaultTrie<String, Int>()
         
        trie.updateValue(1, forKeys: ["a"])
        XCTAssertEqual(trie.getValue(forKeys: ["a"]), 1)
        trie.updateValue(2, forKeys: ["b"])
        XCTAssertEqual(trie.getValue(forKeys: ["b"]), 2)
        trie.updateValue(3, forKeys: ["a"])
        XCTAssertEqual(trie.getValue(forKeys: ["a"]), 3)
    }

}


/**
 Trie test suite.
 */
extension TrieTests {
    
    static var allTests = [
        ("testEmptyTrie", testEmptyTrie),
        ("testCount", testCount),
        ("testGetValue", testGetValue),
    ]
    
}
