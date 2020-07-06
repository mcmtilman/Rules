//
//  RuleEngine.swift
//  Rules
//
//  Created by Michel Tilman on 08/02/2020.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

import Common

/**
 A rule engine provides lookup of rules by means of longest prefix tries using the default (i.e. literal) key matching.
*/
public class RuleEngine<Key> where Key: Hashable {
    
    // MARK: Private stored properties
    
    // Trie supporting lookup of rules, including condition-assertion rules and rule sets.
    // Uses literal key matching.
    private let trie = DefaultTrie<Key, Rule>()
    
    // MARK: Evaluating
    
    /// Looks up the best matching rule for given keys and evaluates it.
    /// Returns nil if no rule is found or if an error occured.
    public func eval<C>(in context: C, forKeys keys: [Key]) -> Bool? {
        try? trie.getBestValue(forKeys: keys)?.eval(in: context)
    }
    
    // MARK: Registering
    
    /// Registers or clears the rule with given keys.
    public func registerRule(_ rule: Rule?, forKeys keys: [Key]) {
        trie.updateValue(rule, forKeys: keys)
    }
    
}
