//
//  CGColor+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension CGColor: DynamicAppearanceType {
    public func customResolved<Base>(for appearance: Appearance<Base>) -> CGColor? {
        dynamicColorProvider?.customResolved(for: appearance)?.cgColor
    }
}
