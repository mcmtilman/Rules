//
//  Contexts.swift
//  Rules
//
//  Created by Michel Tilman on 06/12/2019.
//

/**
 Contextual types provide explicit enumerations of  keypaths, typically keyed by property name.
 
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
 
 # Basic keypaths
 All individual property keypaths can be accessed.
 In order to navigate optional properties we make *Optional<Z>* also contextual.
 
 ```
 extension X: Contextual {
     static let keyPaths: [String: AnyKeyPath] = {
         "x": \Self.x,
         "y": \Self.y,
     ]
 }
 
 extension Y: Contextual {
     static let keyPaths: [String: AnyKeyPath] = {
         "z": \Self.z,
     ]
 }

 extension Z: Contextual {
     static let keyPaths: [String: AnyKeyPath] = {
         "v": \Self.v,
         "w": \Self.w,
     ]
 }

 extension Optional: Contextual where Wrapped == Z {
     static let keyPaths: [String: AnyKeyPath] = [
         "?v": \Self.?.v,
         "?w": \Self.?.w,
     ]
 }
 ```
 
 # Restricted keypaths
 Only some keypaths can be accessed.

 ```
 extension X: Contextual {
    static let keyPaths: [String: AnyKeyPath] = {
        "x": \Self.x,
        "yz?w": \Self.y.z?.w,
    ]
}
```
*/
public protocol Contextual {
    
    static var keyPaths: [String: AnyKeyPath] { get }

}


/**
 Constructs nested keypaths by recusively enumerating properties of contextual types.
 */
public extension Contextual {
    
    /// Returns a combined keypath consisting of individual keypaths, or nil of not possible.
    ///
    /// Construction fails if:
    /// * the list of keys is empty
    /// * some keys are not found
    /// * root or value types do not match.
    ///
    /// # Examples
    /// ```
    /// // Construct \X.x
    /// let keyPath: KeyPath<X, Int> = X.keyPath(for: ["x"])
    ///
    /// // Construct \X.y.z
    /// let keyPath: KeyPath<X, Z?> = X.keyPath(for: ["y", "z"])
    ///
    /// // Construct \X.y.z?.v
    /// let keyPath: KeyPath<X, Int?> = X.keyPath(for: ["y", "z", "?v"])
    /// ```
    static func keyPath<V>(for keys: [String]) -> KeyPath<Self, V>? {
        guard !keys.isEmpty else { return nil }
        
        let keyPath: PartialKeyPath<Self>? = keys.reduce(\.self) { path, key in
            path.flatMap { (type(of: $0).valueType as? Contextual.Type)?.keyPaths[key].flatMap($0.appending) }
        }
        
        return keyPath as? KeyPath<Self, V>
    }

}
