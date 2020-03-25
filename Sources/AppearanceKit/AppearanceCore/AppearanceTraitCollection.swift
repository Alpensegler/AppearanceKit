//
//  AppearanceCollection.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

public protocol AppearanceTraitCollection: AnyObject {
    func configureAppearance()
}

public extension AppearanceTraitCollection {
    var ap: Appearance<Self> { .init(self) }
}

extension AppearanceTraitCollection {
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
