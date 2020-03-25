//
//  UIColor+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIColor: DynamicAppearanceType {
    public func customResolved<Base>(for appearance: Appearance<Base>) -> UIColor? {
        return nil
//        guard #available(iOS 13.0, *), let trait = appearance.traitCollection else { return nil }
//        let value = dynamicColorProvider ?? self
//        let color = value.resolvedColor(with: trait)
//        guard color != self, let result = value.copy() as? UIColor else { return nil }
//        result.dynamicColorProvider = dynamicColorProvider ?? self
//        return result
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
            "UIDynamicSystemColor",
            "UIDynamicModifiedColor",
            "UIDynamicProviderColor",
        ]

        for anyClass in classesToSwizzle.lazy.compactMap(NSClassFromString) {
            swizzle(classType: anyClass.self, selector: #selector(getter: cgColor), functionType: (@convention(c) (UIColor) -> CGColor).self) { (imp) -> @convention(block) (UIColor) -> CGColor in
                return {
                    let color = imp()($0)
                    color.dynamicColorProvider = $0
                    return color
                }
            }
            
            swizzle(classType: anyClass.self, selector: #selector(copy), functionType: (@convention(c) (UIColor) -> UIColor).self) { (imp) -> @convention(block) (UIColor) -> UIColor in
                return {
                    let color = imp()($0)
                    color.dynamicAppearanceProvider = $0.dynamicAppearanceProvider
                    return color
                }
            }
            
            
            swizzle(classType: anyClass.self, selector: #selector(copy(with:)), functionType: (@convention(c) (UIColor, Selector, NSZone?) -> UIColor).self) { (imp) -> @convention(block) (UIColor, Selector, NSZone?) -> UIColor in
                return {
                    let color = imp()($0, $1, $2)
                    color.dynamicAppearanceProvider = $0.dynamicAppearanceProvider
                    return color
                }
            }
            
            swizzle(classType: anyClass.self, selector: #selector(withAlphaComponent(_:)), functionType: (@convention(c) (AnyObject, Selector, CGFloat) -> UIColor).self) { (imp) -> @convention(block) (AnyObject, Selector, CGFloat) -> UIColor in
                return { (obj, sel, alpha) in
                    let rawImplement = imp()
                    let result = rawImplement(obj, sel, alpha)
                    guard let color = obj as? UIColor else { return result }
                    result.dynamicColorProvider = color.dynamicColorProvider.map { rawImplement($0, sel, alpha) }
                    guard let provider = color.dynamicAppearanceProvider?.provider else { return result }
                    result.dynamicAppearanceProvider?.provider = { provider($0).map { rawImplement($0, sel, alpha) } }
                    return result
                }
            }
        }
    }()
}
