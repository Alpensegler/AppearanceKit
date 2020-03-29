//
//  AppearanceAttribute.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/24.
//

import UIKit

protocol AppearanceEnvironmentValue {
    var defaultHashableValue: AnyHashable { get }
    var throughHierarchy: Bool { get }
    var anyHashableGetter: ((UITraitCollection) -> AnyHashable)? { get }
}

public struct AppearanceTrait {
    public struct EnvironmentValue<Value: Hashable>: AppearanceEnvironmentValue {
        let defaultValue: Value
        let throughHierarchy: Bool
        var getter: ((UITraitCollection) -> Value)?
        
        var defaultHashableValue: AnyHashable { defaultValue }
        var anyHashableGetter: ((UITraitCollection) -> AnyHashable)? {
            getter.map { getter in { getter($0) } }
        }
    }
}

public extension AppearanceTrait.EnvironmentValue {
    static func traitCollection(defaultValue: Value, from getter: @escaping (UITraitCollection) -> Value) -> Self {
        return .init(defaultValue: defaultValue, throughHierarchy: false, getter: getter)
    }
    
    static func stored(defaultValue: Value, throughHierarchy: Bool = true) -> Self {
        return .init(defaultValue: defaultValue, throughHierarchy: throughHierarchy)
    }
}

public extension AppearanceTrait {
    var isUserInterfaceDark: EnvironmentValue<Bool> {
        if #available(iOS 13.0, *) {
            return .traitCollection(defaultValue: UITraitCollection.current.userInterfaceStyle == .dark) {
                $0.userInterfaceStyle == .dark
            }
        } else {
            return .stored(defaultValue: false)
        }
    }
}
