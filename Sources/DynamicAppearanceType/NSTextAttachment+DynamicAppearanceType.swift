//
//  NSTextAttachment+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/18.
//

import UIKit

public extension NSTextAttachment {
    static func bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> NSTextAttachment
    ) -> NSTextAttachment {
        _bindEnvironment(keyPath, by: provider)
    }
    
    func resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> NSTextAttachment? {
        if let resolved = _resolved(for: appearance) { return resolved }
        let provider = image?.dynamicProvider
        if let resolvedImage = image?.resolved(for: appearance) {
            self.image = resolvedImage
            return self
        }
        guard #available(iOS 13, *), let assets = image?.imageAsset, let isDark = appearance[\.isUserInterfaceDark, notEqualTo: lastUserInterfaceStyle] else { return nil }
        lastUserInterfaceStyle = isDark
        self.image = assets.image(with: isDark ? UITraitCollection(userInterfaceStyle: .dark) : UITraitCollection(userInterfaceStyle: .light))
        self.image?.dynamicProvider = provider
        return self
    }
    
    var resloved: NSTextAttachment? { isDynamic ? self : nil }
    
    var isDynamic: Bool {
        if dynamicProvider != nil || image?.dynamicProvider != nil { return true }
        if #available(iOS 13, *), image?.imageAsset != nil { return true }
        return false
    }
}

extension NSTextAttachment: DynamicProvidableAppearanceType {
    var dynamicProvider: DynamicProvider<NSTextAttachment>? {
        get { getAssociated(\.dynamicProvider) }
        set { setAssociated(\.dynamicProvider, newValue) }
    }
    
    var lastUserInterfaceStyle: AnyHashable {
        get { getAssociated(\.lastUserInterfaceStyle, initialValue: AnyHashable(0)) }
        set { setAssociated(\.lastUserInterfaceStyle, newValue) }
    }
}
