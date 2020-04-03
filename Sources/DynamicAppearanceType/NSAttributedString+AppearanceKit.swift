//
//  NSAttributedString+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/18.
//

import UIKit

extension NSAttributedString: DynamicAppearanceType {
    var dynamicProvider: DynamicProvider<NSAttributedString>? {
        get { getAssociated(\NSAttributedString.dynamicProvider) }
        set { setAssociated(\NSAttributedString.dynamicProvider, newValue) }
    }
}

public extension NSAttributedString {
    static func bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> NSAttributedString
    ) -> NSAttributedString {
        let (resolved, dynamicProvider) = DynamicProvider.fromBind(keyPath, by: provider)
        resolved.dynamicProvider = dynamicProvider
        return resolved
    }
    
    func resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> NSAttributedString? {
        guard let (resolved, dynamicProvider) = dynamicProvider?.resolved(for: appearance) else { return nil }
        resolved.dynamicProvider = dynamicProvider
        return resolved
    }
}
