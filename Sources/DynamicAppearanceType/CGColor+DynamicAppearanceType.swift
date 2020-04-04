//
//  CGColor+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension CGColor: StoredDynamicProvidableAppearanceType {
    var dynamicProvider: StoredDynamicProvider<CGColor>? {
        get { Associator(self).getAssociated("dynamicProvider") }
        set { Associator(self).setAssociated("dynamicProvider", newValue) }
    }
    
    static var defaultBase: CGColor { CGColor(colorSpace: CGColorSpace(name: CGColorSpace.linearGray)!, components: [0, 0])! }
}

public extension CGColor {
    static func bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> CGColor
    ) -> CGColor {
        _bindEnvironment(keyPath, by: provider)
    }
    
    func resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> CGColor? {
        _resolved(for: appearance)
    }
}
