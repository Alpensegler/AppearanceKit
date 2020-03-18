//
//  UIColor+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIColor: DynamicAppearanceType {
    public static var defaultAppearance: UIColor { .black }
    
    public func resolved(for appearance: Appearance) -> UIColor? {
        let resolved = _resolved(for: appearance)
        guard #available(iOS 13.0, *) else {
            return resolved?._addingProvider(dynamicAppearanceProvider)
        }
        let color = (resolved ?? self).resolvedColor(with: appearance.traitCollection)
        guard color != self, let copyColor = copy() as? UIColor else { return nil }
        return color._addingProvider(dynamicAppearanceProvider ?? { _ in copyColor })
    }
}

extension UIColor {
    static let swizzleForAppearanceOne: Void = {
        UIColor.swizzle(selector: #selector(getter: cgColor), to: #selector(_cgColor))
    }()
    
    @objc func _cgColor() -> CGColor {
        let color = _cgColor()
        guard let dynamicAppearanceProvider = dynamicAppearanceProvider else { return color }
        color.dynamicAppearanceProvider = {
            var color = dynamicAppearanceProvider($0)
            while let resolved = color.resolved(for: $0) {
                color = resolved
            }
            return color.cgColor
        }
        return color
    }
    
    @objc func _withAlphaComponent(_ alpha: CGFloat) -> UIColor {
        let color = _withAlphaComponent(alpha)
        guard let provider = dynamicAppearanceProvider else { return color }
        color.dynamicAppearanceProvider = { provider($0).withAlphaComponent(alpha) }
        return color
    }
}
