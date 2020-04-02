//
//  CGColor+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension CGColor: DynamicAppearanceType {
    public func customResolved<Base>(for appearance: Appearance<Base>) -> CGColor? {
        guard let cgColor = dynamicColorProvider?.customResolved(for: appearance)?.cgColor else { return nil }
        cgColor.dynamicColorProvider = dynamicColorProvider
        return cgColor
    }
    
    var dynamicColorProvider: UIColor? {
        get { Associator(self).getAssociated("dynamicColorProvider") }
        set { Associator(self).setAssociated("dynamicColorProvider", newValue) }
    }
    
}
