//
//  UIImage+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIImage: DynamicAppearanceType {
    public func customResolved(for appearance: Appearance) -> UIImage? {
        imageAsset?.image(with: appearance.traitCollection)
    }
}
