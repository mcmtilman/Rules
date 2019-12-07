//
//  Contexts.swift
//  Rules
//
//  Created by Michel Tilman on 06/12/2019.
//  Copyright © 2019 Dotted.Pair.
//  Licensed under Apache License v2.0.
//

/**
 Contextual types provide explicit enumerations of  key paths, typically keyed by property name.
 
 # Example model
 
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
 
 # Basic key paths
 All individual property key paths can be accessed.
 
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
 
 # Explicit nested key paths
 Only the root context adopts the Contexual protocol.
 Key paths from the root to properties of 'nested'' types are listed explicitly.

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
    
    /// Returns a dictionary of key paths.
    static var keyPaths: [String: AnyKeyPath] { get }

    /// Returns a dictionary of key paths for the optional type.
    static var optionalKeyPaths: [String: AnyKeyPath] { get }

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

    /// Returns an empty dictionary of key paths for the optional type by default.
    static var optionalKeyPaths: [String: AnyKeyPath] {
        [:]
    }

    // MARK: Constructing key paths
    
    /// Returns a combined key path consisting of individual key paths, or nil of not possible.
    ///
    /// Construction fails if:
    /// * the list of keys is empty
    /// * some keys are not found
    /// * root or value types do not match.
    ///
    /// # Examples using basic model
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
            path.flatMap { (type(of: $0).valueType as? Contextual.Type)?.keyPaths[key].flatMap($0.appending) }
        }
        
        return keyPath as? KeyPath<Self, V>
    }

}

/**
 Optional types delegate requests for their key paths to the wrapped types.
 */
extension Optional: Contextual where Wrapped: Contextual {
    
    /// Returns the optional key paths defined by the wrapped type.
    public static var keyPaths: [String: AnyKeyPath] {
        Wrapped.optionalKeyPaths
    }

}
