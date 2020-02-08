//
//  Trie.swift
//  Rules
//
//  Created by Michel Tilman on 01/02/2020.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

/**
 Protocol for trie nodes.
 Nodes are structured as a tree. Child nodes are identified by key. Each node may store an optional value.
 The presence of a value in a node indicates if a path of keys from the trie root to the node represents a key-value pair.
 A default implementation may use a map to link keys to child nodes.
*/
public protocol TrieNode {

    // MARK: Associated types
    
    associatedtype Key
    associatedtype Value
    
    // MARK: Properties
    
    /// Returns the number of nodes in this node's subtrie (including the node) with non-empty value.
    var count: Int { get }

    /// Optional value, nil if a key path leading from the trie's root ending with this node has no value.
    var value: Value? { get set }

    // MARK: Initializing
    
    /// Default initializer.
    init()

    // MARK: Acessing / constructing child nodes
    
    /// Returns (or sets) the child node identified by given key, or nil if it does not exist.
    subscript(k: Key) -> Self? { get set }

    /// Returns the child node identified by given key.
    /// Creates the child node if missing.
    func childNodeWithKey(_ key: Key) -> Self
    
}


/**
 Prefix trie structure consisting of nodes containing an optional value and zero or more child nodes.
*/
public class Trie<Key, Value, Node> where Node: TrieNode, Key == Node.Key, Value == Node.Value {
    
    // MARK: Computed properties
    
    /// Returns the number of nodes with non-nil value.
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
    public func getBestValue<K>(forKeys keys: K) -> Value? where K: Collection, K.Element == Key {
        guard !keys.isEmpty else { return nil }
        var node = root
        var lastValue = node.value
        
        for key in keys {
            guard let childNode = node[key] else { return lastValue }
            node = childNode
            if let value = node.value { lastValue = value }
        }
        
        return lastValue
    }
    
    /// Returns the value of the node identified by given key chain, or nil if no such node exists.
    public func getValue<K>(forKeys keys: K) -> Value? where K: Collection, K.Element == Key {
        guard !keys.isEmpty else { return nil }
        var node = root
        
        for key in keys {
            guard let childNode = node[key] else { return nil }
            node = childNode
        }
        
        return node.value
    }
    
    // MARK: Updating
    
    /// Updates the value of the node identified by given key chain, extending the trie if necessary.
    /// A nil value clears the node's value, but does not restructure the trie.
    public func updateValue<K>(_ value: Value?, forKeys keys: K) where K: Collection, K.Element == Key {
        guard !keys.isEmpty else { return }
        var node = root
        
        for key in keys {
            node = node.childNodeWithKey(key)
        }
        node.value = value
    }
    
}

/**
 Deafult implementation of a trie node.
 Maintains an optional value and links to zero or more child nodes.
 Looking up nodes by key is based on a literal match.
 */
public final class Node<Key, Value>: TrieNode where Key: Hashable {

    // MARK: Stored properties
    
    /// Optional value, nil if a key path leading to and ending with this node has no value.
    public var value: Value?
    
    // MARK: Private stored properties
    
    /// Links to zero or more child nodes.
    private var children = [Key: Node]()

    // MARK: Computed properties
    
    /// Returns the number of nodes in this node's subtrie with non-empty value.
    public var count: Int {
        children.values.reduce(value == nil ? 0 : 1) { sum, node in sum + node.count }
    }

    // MARK: Initializing
    
    /// Public default initializer.
    public init() {}
    
    // MARK: Accessing / constructing trie nodes
     
    /// Returns (or sets) the child node identified by given key, or nil if it does not exist.
    public subscript(k: Key) -> Node? {
        get { children[k] }
        set { children[k] = newValue }
    }
    
    /// Returns the child node identified by given key.
    /// Creates the child node if missing.
    public func childNodeWithKey(_ key: Key) -> Node {
        if let node = self[key] { return node }
        let node = Node()
             
        self[key] = node
             
        return node
    }

}


/**
 Trie using default node impementation.
 */
public class DefaultTrie<Key, Value>: Trie<Key, Value, Node<Key, Value>> where Key: Hashable {}
