//
//  UIImage+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIImage: DynamicAppearanceType {
    public func resolved(for appearance: Appearance) -> UIImage? {
        let image = _resolved(for: appearance)
        guard let imageAsset = (image ?? self).imageAsset else {
            return image?._addingProvider(dynamicAppearanceProvider)
        }
        let resolvedImage = imageAsset.image(with: appearance.traitCollection)
        if resolvedImage == self { return nil }
        return resolvedImage._addingProvider(dynamicAppearanceProvider)
    }
}
