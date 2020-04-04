//
//  UIColor+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

public extension UIColor {
    static func bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> UIColor
    ) -> UIColor {
        _bindEnvironment(keyPath, by: provider)
    }
    
    func resolved<Base>(for appearance: Appearance<Base>) -> UIColor? {
        _resolved(for: appearance)
    }
    
    var dynamicCGColor: CGColor {
        guard userInterFaceProvider != nil || isDynamicUIColor else { return cgColor }
        let (light, dark) = (lightColor, darkColor)
        return .init(lightAppearance: light.cgColor, darkAppearance: dark.cgColor)
    }
    
    var lightColor: UIColor {
        if let provider = userInterFaceProvider {
            return provider.provider.provider(false)
        }
        guard isDynamicUIColor, #available(iOS 13, *) else { return self }
        return resolvedColor(with: .init(userInterfaceStyle: .light))
    }
    
    var darkColor: UIColor {
        if let provider = userInterFaceProvider {
            return provider.provider.provider(true)
        }
        guard #available(iOS 13, *) else { return self }
        return resolvedColor(with: .init(userInterfaceStyle: .dark))
    }
}

extension UIColor: StoredDynamicProvidableAppearanceType {
    static var defaultBase: UIColor { .init(cgColor: .defaultBase) }
    
    static let dynamicClasses: Set = [
        "UIDynamicSystemColor",
        "UIDynamicModifiedColor",
        "UIDynamicProviderColor",
    ]
    
    var dynamicProvider: StoredDynamicProvider<UIColor>? {
        get { getAssociated(\.dynamicProvider) }
        set { setAssociated(\.dynamicProvider, newValue) }
    }
    
    var isDynamicUIColor: Bool {
        guard UIColor.dynamicClasses.contains(NSStringFromClass(type(of: self))) else { return false }
        return true
    }
    
    var userInterFaceProvider: StoredDynamicProvider<UIColor>? {
        guard let provider = dynamicProvider, provider.provider.key == (\AppearanceTrait.isUserInterfaceDark).hashValue else { return nil }
        return provider
    }
}
