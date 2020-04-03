//
//  CGColor+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension CGColor: DynamicAppearanceType {
    var dynamicProvider: StoredDynamicProvider<CGColor>? {
        get { Associator(self).getAssociated("dynamicProvider") }
        set { Associator(self).setAssociated("dynamicProvider", newValue) }
    }
    
    static var defaultClear: CGColor { CGColor(colorSpace: CGColorSpace(name: CGColorSpace.linearGray)!, components: [0, 0])! }
}

public extension CGColor {
    static func bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> CGColor
    ) -> CGColor {
        let color = CGColor.defaultClear
        color.dynamicProvider = .init(keyPath, by: provider)
        return color
    }
    
    func resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> CGColor? {
        dynamicProvider?.resolved(for: appearance)?.resolved
    }
    
    func debugPrint() {
        print(dynamicProvider)
    }
}
