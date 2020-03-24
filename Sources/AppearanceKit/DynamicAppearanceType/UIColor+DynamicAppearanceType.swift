//
//  UIColor+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIColor: DynamicAppearanceType {
    public func customResolved<Base>(for appearance: Appearance<Base>) -> UIColor? {
        guard #available(iOS 13.0, *), let trait = appearance.traitCollection else { return nil }
        let value = dynamicColorProvider ?? self
        let color = value.resolvedColor(with: trait)
        guard color != self, let result = value.copy() as? UIColor else { return nil }
        result.dynamicColorProvider = dynamicColorProvider ?? self
        return result
    }
}

extension UIColor {
    static let swizzleForAppearanceOne: Void = {
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
            swizzle(classType: anyClass.self, selector: #selector(getter: cgColor), functionType: (@convention(c) (UIColor) -> CGColor).self) { (imp) -> @convention(block) (UIColor) -> CGColor in
                return {
                    let color = imp()($0)
                    color.dynamicColorProvider = $0.copy() as? UIColor
                    return color
                }
            }
            
            swizzle(classType: anyClass.self, selector: #selector(withAlphaComponent(_:)), functionType: (@convention(c) (UIColor, Selector, CGFloat) -> UIColor).self) { (imp) -> @convention(block) (UIColor, Selector, CGFloat) -> UIColor in
                return { (obj, sel, alpha) in
                    let rawImplement = imp()
                    let color = rawImplement(obj, sel, alpha)
                    color.dynamicColorProvider = obj.dynamicColorProvider.map { rawImplement($0, sel, alpha) }
                    guard let provider = obj.dynamicAppearanceProvider?.provider else { return color }
                    color.dynamicAppearanceProvider?.provider = { provider($0).map { rawImplement($0, sel, alpha) } }
                    return color
                }
            }
        }
    }()
}
