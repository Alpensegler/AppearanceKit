//
//  UIColor+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIColor: DynamicAppearanceType {
    public static var defaultAppearance: UIColor { .black }
    
    public func customResolved(for appearance: Appearance) -> UIColor? {
        guard #available(iOS 13.0, *) else { return nil }
        let color = resolvedColor(with: appearance.traitCollection)
        guard color != self else { return nil }
        return copy() as? UIColor
    }
}

extension UIColor {
    static let swizzleForAppearanceOne: Void = {
        UIColor.swizzle(selector: #selector(withAlphaComponent(_:)), to: #selector(_withAlphaComponent(_:)))
        
        let classesToSwizzle: [String] = [
            "UIColor",
            "UIDeviceRGBColor",
            "UIDisplayP3Color",
            "UIPlaceholderColor",
            "UICIColor",
            "UIDeviceWhiteColor",
            "UICGColor",
            "UICachedDeviceRGBColor",
            "UICachedDeviceWhiteColor",
            "UICachedDevicePatternColor",
            "UIDynamicProviderColor",
        ]

        for anyClass in classesToSwizzle.lazy.compactMap(NSClassFromString) {
            swizzle(classType: anyClass.self, selector: #selector(getter: cgColor), functionType: (@convention(c) (AnyObject?) -> CGColor).self) { (imp) -> @convention(block) (AnyObject?) -> CGColor in
                return {
                    let color = imp()($0)
                    guard let copy = ($0 as? UIColor)?.copy() as? UIColor else { return color }
                    color.dynamicAppearanceProvider = { imp()(copy.resolved(for: $0) ?? copy) }
                    return color
                }
            }
        }
    }()
    
    @objc func _withAlphaComponent(_ alpha: CGFloat) -> UIColor {
        let color = _withAlphaComponent(alpha)
        guard let provider = dynamicAppearanceProvider else { return color }
        color.dynamicAppearanceProvider = { provider($0).withAlphaComponent(alpha) }
        return color
    }
}
