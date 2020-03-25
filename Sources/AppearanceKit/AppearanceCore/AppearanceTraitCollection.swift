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
    var ap: Appearance<Self> {
        get { _ap }
        set {
            if newValue.changingTrait.isEmpty { return }
            _ap = newValue
            configureAppearance()
            _ap.changingTrait.removeAll()
        }
    }
}

extension AppearanceTraitCollection {
    var _ap: Appearance<Self> {
        get { .init(appearanceType: Associator(self).getAssociated("appearanceKit.appearance"), self) }
        set { Associator(self).setAssociated("appearanceKit.appearance", newValue as StoredAppearance) }
    }
    
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
