//
//  AppearanceTrait.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/24.
//

import UIKit

public struct AppearanceTrait {
    public struct Environment<Value: Hashable, Attribute> {
        let value: Value
        let attribute: Attribute
    }
}

public typealias StoredEnvironment<Value: Hashable> = AppearanceTrait.Environment<Value, Void>
public typealias UITraitEnvironment<Value: Hashable> = AppearanceTrait.Environment<Value, (UITraitCollection) -> Value>

public extension AppearanceTrait.Environment where Attribute == Void {
    init(defaultValue: Value) {
        value = defaultValue
    }
}

public extension AppearanceTrait.Environment where Attribute == (UITraitCollection) -> Value {
    init(defaultValue: Value, from getter: @escaping (UITraitCollection) -> Value) {
        value = defaultValue
        attribute = getter
    }
}

public extension AppearanceTrait {
    var isUserInterfaceDark: UITraitEnvironment<Bool> {
        if #available(iOS 13.0, *) {
            return .init(defaultValue: UITraitCollection.current.userInterfaceStyle == .dark) {
                $0.userInterfaceStyle == .dark
            }
        } else {
            return .init(defaultValue: false) { _ in false }
        }
    }
}

typealias AnyEnvironment<Attribute> = AppearanceTrait.Environment<AnyHashable, Attribute>
