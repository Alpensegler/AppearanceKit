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

public extension AppearanceEnvironment {
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
}

extension AppearanceEnvironment {
    var traits: Traits<Void> { ap.traits }
}

extension NSObject {
    @objc func configureAppearanceChange() { }
}
