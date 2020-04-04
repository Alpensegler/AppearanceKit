//
//  UIImage+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

public extension UIImage {

    static func bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> UIImage
    ) -> UIImage {
        _bindEnvironment(keyPath, by: provider)
    }
    
    func resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> UIImage? {
        _resolved(for: appearance)
    }
    
    var lightImage: UIImage {
        if let provider = dynamicProvider, provider.key == (\AppearanceTrait.isUserInterfaceDark).hashValue {
            return provider.provider(false)
        }
        guard #available(iOS 13, *), let assets = imageAsset else { return self }
        return assets.image(with: .init(userInterfaceStyle: .light))
    }
    
    var darkImage: UIImage {
        if let provider = dynamicProvider, provider.key == (\AppearanceTrait.isUserInterfaceDark).hashValue {
            return provider.provider(true)
        }
        guard #available(iOS 13, *), let assets = imageAsset else { return self }
        return assets.image(with: .init(userInterfaceStyle: .dark))
    }
}

extension UIImage: DynamicProvidableAppearanceType {
    var dynamicProvider: DynamicProvider<UIImage>? {
        get { getAssociated(\.dynamicProvider) }
        set { setAssociated(\.dynamicProvider, newValue) }
    }
    
}
