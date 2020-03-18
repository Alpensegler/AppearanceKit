//
//  CGColor+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension CGColor: DynamicAppearanceType {
    public static var defaultAppearance: CGColor { UIColor.white.cgColor }
}
