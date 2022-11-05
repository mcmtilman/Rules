//
//  Contexts.swift
//  Rules
//
//  Created by Michel Tilman on 06/12/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

/**
 Contextual types provide explicit enumerations of supported key paths, keyed by name.
 The names may correspond to individual properties, but they may also represent
 more complex key paths.
 
 Types adopting the *Contextual* protocol may register key paths for both the types themselves
 and when used as optionals.
 
 # Example model
 
 The following model is extended in multiple ways with *contextual awareness*.
 * The first extension example provides single-key paths for properties only. Key paths of multiple types
 may then be combined to build multi-key paths.
 * The second extension example provides all key paths at the level of the root context, and includes a
 combination of single- and multi-key paths.
 
 ```
 struct X {
     let x: Int
     let y: Y
 }

 struct Y {
     let z: Z?
 }

 struct Z {
     let v: Int
     let w: [Int]
 }
 ```
 
 # Single-property paths only
 
 Individual single (property) key paths are available for all types. Multi-key paths must be assembled.
 
 ```
 extension X: Contextual {
     static let keyPaths: [String: AnyKeyPath] = [
         "x": \Self.x,
         "y": \Self.y,
     ]
 }
 
 extension Y: Contextual {
     static let keyPaths: [String: AnyKeyPath] = [
         "z": \Self.z,
     ]
 }

 extension Z: Contextual {
     static let keyPaths: [String: AnyKeyPath] = [
         "v": \Self.v,
         "w": \Self.w,
     ]
     static let optionalKeyPaths: [String: AnyKeyPath] = [
         "v": \Self?.?.v,
         "w": \Self?.?.w,
     ]
 }
 ```
 
 # Root context key paths only
 
 Only the root context adopts the *Contexual* protocol.
 Key paths from the root to properties of 'nested'' types restrict access to specific chains.

 ```
 extension X: Contextual {
    static let keyPaths: [String: AnyKeyPath] = [
        "x": \Self.x,
        "yzw": \Self.y.z?.w,
    ]
}
```
*/
public protocol Contextual {
    
    /// Returns a dictionary of registered key paths.
    static var keyPaths: [String: AnyKeyPath] { get }

    /// Returns a dictionary of registered optional type key paths.
    static var optionalKeyPaths: [String: AnyKeyPath] { get }

    /// Returns a known key path for given key, or nil if not found
    static func keyPath(for key: String) -> AnyKeyPath?
    
    /// Returns a known optional type key path for given key, or nil if not found
    static func optionalKeyPath(for key: String) -> AnyKeyPath?
    
}


/**
 Constructs nested key paths by recusively enumerating properties of contextual types.
 */
public extension Contextual {
    
    // MARK: Registered key paths
    
    /// Returns an empty dictionary of key paths by default.
    static var keyPaths: [String: AnyKeyPath] {
        [:]
    }

    /// Returns an empty dictionary of optional type key paths by default.
    static var optionalKeyPaths: [String: AnyKeyPath] {
        [:]
    }

    // MARK: Accessing known key paths
    
    /// Returns a known key path for given key, or nil if not found
    /// By default this is a registered key path.
    static func keyPath(for key: String) -> AnyKeyPath? {
        keyPaths[key]
    }

    /// Returns a known optional type key path for given key, or nil if not found.
    /// By default this is a registered optional type key path.
    static func optionalKeyPath(for key: String) -> AnyKeyPath? {
        optionalKeyPaths[key]
    }

    // MARK: Combining key paths
    
    /// Returns a combined key path consisting of known key paths, or nil if not possible.
    /// Generic parameter V denotes the expected value type of the key path.
    ///
    /// Construction fails if:
    /// * the list of keys is empty
    /// * some keys are not found
    /// * root or value types do not match.
    ///
    /// # Examples using single-property paths model
    /// ```
    /// // Construct \X.x
    /// let keyPath: KeyPath<X, Int> = X.keyPath(for: ["x"])
    ///
    /// // Construct \X.y.z
    /// let keyPath: KeyPath<X, Z?> = X.keyPath(for: ["y", "z"])
    ///
    /// // Construct \X.y.z?.v
    /// let keyPath: KeyPath<X, Int?> = X.keyPath(for: ["y", "z", "v"])
    /// ```
    static func keyPath<V>(for keys: [String]) -> KeyPath<Self, V>? {
        guard !keys.isEmpty else { return nil }
        
        let keyPath: PartialKeyPath<Self>? = keys.reduce(\.self) { path, key in
            path.flatMap { (type(of: $0).valueType as? Contextual.Type)?.keyPath(for: key).flatMap($0.appending) }
        }
        
        return keyPath as? KeyPath<Self, V>
    }

}


/**
 Optional types delegate requests for their key paths to their wrapped types.
 */
extension Optional: Contextual where Wrapped: Contextual {
    
    /// Returns the optional type key path defined by the wrapped type.
     public static func keyPath(for key: String) -> AnyKeyPath? {
        Wrapped.optionalKeyPath(for: key)
    }

}


/**
 Dictionaries support dynamic creation of a key path given a dictionary key.
 */
extension Dictionary: Contextual where Key == String {
    
    /// Returns a key path for given dictionary key.
    /// The key may not exist.
    public static func keyPath(for key: String) -> AnyKeyPath? {
        \Self[key]
    }

    /// Returns a key path for given optional dictionary key.
    /// The key may not exist.
    public static func optionalKeyPath(for key: String) -> AnyKeyPath? {
        \Self?.?[key]
    }

}


/**
 Arrays support dynamic creation of a key path given an array index.
 Key paths use failable subscripts.
*/
extension Array: Contextual {
    
    // MARK: Contextual conformance
    
    /// Returns a key path for given key representing an array index, or nil otherwise.
    /// The index may not exist.
    public static func keyPath(for key: String) -> AnyKeyPath? {
        guard let index = Int(key) else { return nil }
        
        return \Self[failable: index]
    }

    /// Returns a key path for given optional array key representing an array index, or nil otherwise.
    /// The index may not exist.
    public static func optionalKeyPath(for key: String) -> AnyKeyPath? {
        guard let index = Int(key) else { return nil }
        
        return \Self?.?[failable: index]
    }

    // MARK: Subscripting
    
    // Returns the element at given index if the index is in range, nil otherwise.
    public subscript(failable index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        
        return self[index]
    }
    
}
