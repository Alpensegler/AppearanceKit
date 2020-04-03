//
//  NSTextAttachment+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/18.
//

import UIKit

extension NSTextAttachment: DynamicAppearanceType {
    var dynamicProvider: DynamicProvider<NSTextAttachment>? {
        get { getAssociated(\NSTextAttachment.dynamicProvider) }
        set { setAssociated(\NSTextAttachment.dynamicProvider, newValue) }
    }
}

public extension NSTextAttachment {
    static func bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> NSTextAttachment
    ) -> NSTextAttachment {
        let (resolved, dynamicProvider) = DynamicProvider.fromBind(keyPath, by: provider)
        resolved.dynamicProvider = dynamicProvider
        return resolved
    }
    
    func resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> NSTextAttachment? {
        guard let (resolved, dynamicProvider) = dynamicProvider?.resolved(for: appearance) else { return nil }
        resolved.dynamicProvider = dynamicProvider
        return resolved
    }
}
