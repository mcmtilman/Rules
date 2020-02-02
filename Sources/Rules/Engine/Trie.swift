//
//  Trie.swift
//  Rules
//
//  Created by Michel Tilman on 01/02/2020.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

/**
 Trie matchers determine if a given trie node matches a key in a key chain.
*/
public protocol TrieMatcher {
    
    /// Returns true if the key matches.
    func matches<K>(key: K) throws -> Bool

}


/**
 Prefix trie structure consisting of nodes containing an optional value and zero or more child nodes.
*/
public class Trie<Key, Value> where Key: Hashable {
    
    // Maintains an optional value and links to zero or more child nodes.
    // If the value is nil, the key chain leading to and ending with the node has no value.
    private class Node {
        
        // MARK: Stored properties
        
        /// Links to zero or more child nodes.
        var childNodes = [Key: Node]()
        
        /// Optional value, nil if a key chain leading to and ending with this node has no value.
        var value: Value?
        
        // MARK: Computed properties
        
        /// Returns the number of child nodes with non-nil value, including this node.
        var count: Int {
            let childCount = childNodes.values.reduce(0) { sum, node in sum + node.count }
            
            return value == nil ? childCount : childCount + 1
        }
        
        // MARK: Accessing / constructing trie
        
        /// Returns the node identified by given key path.
        /// Creates the child node if missing.
        func childNodeWithKey(_ key: Key) -> Node {
            if let node = childNodes[key] { return node }
            let node = Node()
                
            childNodes[key] = node
                
            return node
        }

    }
    
    // MARK: Computed properties
    
    public var count: Int {
        root.count
    }
    
    // MARK: Private stored properties
    
    // Root node. Does not contain a value.
    private let root = Node()
    
    // MARK: Initializing
    
    /// Default initializer
    public init() {}
    
    // MARK: Accessing
    
    /// Returns the non-nil value of the node with longest prefix of given key chain, if such a node exists,
    /// Returns nil otherwise.
    public func getLastValue<K>(forKeys keys: K) -> Value? where K: Collection, K.Element == Key {
        var node = root
        var lastValue = node.value
        
        for key in keys {
            guard let childNode = node.childNodes[key] else { return lastValue }
            node = childNode
            if let value = node.value { lastValue = value }
        }
        
        return lastValue
    }
    
    /// Returns the value of the node identified by given key chain, or nil if no such node exists.
    public func getValue<K>(forKeys keys: K) -> Value? where K: Collection, K.Element == Key {
        var node = root
        
        for key in keys {
            guard let childNode = node.childNodes[key] else { return nil }
            node = childNode
        }
        
        return node.value
    }
    
    // MARK: Updating
    
    /// Updates the value of the node identified by given key chain, extending the trie if necessary.
    public func updateValue<K>(_ value: Value, forKeys keys: K) where K: Collection, K.Element == Key {
        guard !keys.isEmpty else { return }
        var node = root
        
        for key in keys {
            node = node.childNodeWithKey(key)
        }
        node.value = value
    }
    
}
