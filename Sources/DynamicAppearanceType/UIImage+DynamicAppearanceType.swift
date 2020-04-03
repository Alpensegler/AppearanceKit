//
//  UIImage+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIImage: DynamicAppearanceType {
    public static func bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> UIImage
    ) -> UIImage {
        let (image, dynamicProvider) = DynamicProvider.fromBind(keyPath, by: provider)
        image.dynamicProvider = dynamicProvider
        return image
    }

    public func resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> UIImage? {
        guard let (image, dynamicProvider) = dynamicProvider?.resolved(for: appearance) else { return nil }
        image.dynamicProvider = dynamicProvider
        return image
    }
}

extension UIImage {
    var dynamicProvider: DynamicProvider<UIImage>? {
        get { getAssociated(\.dynamicProvider) }
        set { setAssociated(\.dynamicProvider, newValue) }
    }
    
}
