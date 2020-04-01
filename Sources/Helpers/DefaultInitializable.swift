//
//  DefaultInitializable.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

public protocol DefaultInitializable {
    init()
}

extension String: DefaultInitializable { }
extension Int: DefaultInitializable { }
extension Bool: DefaultInitializable { }
extension Int32: DefaultInitializable { }
extension Int64: DefaultInitializable { }
extension UInt64: DefaultInitializable { }
extension Double: DefaultInitializable { }
extension Float: DefaultInitializable { }
extension Array: DefaultInitializable { }
extension Dictionary: DefaultInitializable { }
extension Set: DefaultInitializable { }
extension Optional: DefaultInitializable {
    public init() { self = .none }
}

import Foundation
extension Date: DefaultInitializable { }
extension Data: DefaultInitializable { }
