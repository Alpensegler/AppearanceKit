//
//  AppearanceCollection.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

public protocol AppearanceEnvironment: NSObject {
    func configureAppearance()
}

public extension AppearanceEnvironment {
    var ap: Appearance<Self> { .init(self) }
}

extension AppearanceEnvironment {
    func update<Base, Value>(to appearance: Appearance<Base>, _ getter: Value?, _ setter: (Value?) -> Void)
    where Value: DynamicAppearanceType, Value.DynamicAppearanceBase == Value {
        if let resolved = getter?.resolved(for: appearance) {
            setter(resolved)
        }
    }
    
    func update<Value, Base>(to appearance: Appearance<Base>, _ dynamicAppearanceType: inout Value?)
    where Value: DynamicAppearanceType, Value.DynamicAppearanceBase == Value {
        update(to: appearance, dynamicAppearanceType) { dynamicAppearanceType = $0 }
    }
    
    func setDynamicValue<Value>(_ value: Value?, store: inout Value?, setter: (Value?) -> Void)
    where Value: ProvidableAppearanceType, Value.DynamicAppearanceBase == Value {
        guard let resolved = value?.resloved else {
            setter(value)
            store = nil
            return
        }
        setter(resolved)
        store = value
        let appearance = ap
        if appearance.didConfigureOnce {
            update(to: appearance, value, setter)
        }
    }
}

extension AppearanceEnvironment {
    var traits: Traits<Void> { ap.traits }
}

extension NSObject {
    @objc func configureAppearanceChange() { }
}
