//
//  UIImage+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIImage: DynamicAppearanceType {
    public func customResolved<Base>(for appearance: Appearance<Base>) -> UIImage? {
        guard let traitCollection = appearance.traitCollection else { return nil }
        return imageAsset?.image(with: traitCollection)
    }
}
