//
//  UIColor+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIColor: DynamicAppearanceType {
    static let dynamicClasses: Set = [
        "UIDynamicSystemColor",
        "UIDynamicModifiedColor",
        "UIDynamicProviderColor",
    ]
    
    var dynamicProvider: StoredDynamicProvider<UIColor>? {
        get { getAssociated(\.dynamicProvider) }
        set { setAssociated(\.dynamicProvider, newValue) }
    }
}

public extension UIColor {
    static func bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> UIColor
    ) -> UIColor {
        let color = UIColor(cgColor: .defaultClear)
        color.dynamicProvider = .init(keyPath, by: provider)
        return color
    }
    
    func resolved<Base>(for appearance: Appearance<Base>) -> UIColor? {
        dynamicProvider?.resolved(for: appearance)?.resolved
    }
    
    var dynamicCGColor: CGColor {
        guard UIColor.dynamicClasses.contains(NSStringFromClass(type(of: self))), #available(iOS 13, *) else { return cgColor }
        let light = resolvedColor(with: .init(userInterfaceStyle: .light))
        let dark = resolvedColor(with: .init(userInterfaceStyle: .dark))
        return .init(lightAppearance: light.cgColor, darkAppearance: dark.cgColor)
    }
}
