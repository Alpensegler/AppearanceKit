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
        guard UIColor.dynamicClassesToSwizzleString.contains(NSStringFromClass(type(of: value))) else { return nil }
        _ = appearance.isUserInterfaceDark
        let color = value.resolvedColor(with: trait)
        guard color != self, let result = value.copy() as? UIColor else { return nil }
        result.dynamicColorProvider = dynamicColorProvider ?? self
        return result
    }
}

extension UIColor {
    static let dynamicClassesToSwizzleString: Set = [
        "UIDynamicSystemColor",
        "UIDynamicModifiedColor",
        "UIDynamicProviderColor",
    ]
    
    static let dynamicClassesToSwizzle = dynamicClassesToSwizzleString.compactMap(NSClassFromString)
    
    static let classesToSwizzle = [
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
    ].compactMap(NSClassFromString)
    
    static let swizzleForAppearanceOne: Void = {

        for anyClass in dynamicClassesToSwizzle {
            swizzle(classType: anyClass.self, selector: #selector(getter: cgColor), functionType: (@convention(c) (UIColor) -> CGColor).self) { (imp) -> @convention(block) (UIColor) -> CGColor in
                return {
                    let color = imp()($0)
                    color.dynamicColorProvider = $0
                    return color
                }
            }
        }
        

        for anyClass in classesToSwizzle {
            swizzle(classType: anyClass.self, selector: #selector(withAlphaComponent(_:)), functionType: (@convention(c) (AnyObject, Selector, CGFloat) -> UIColor).self) { (imp) -> @convention(block) (AnyObject, Selector, CGFloat) -> UIColor in
                return { (obj, sel, alpha) in
                    let rawImplement = imp()
                    let result = rawImplement(obj, sel, alpha)
                    guard let color = obj as? UIColor else { return result }
                    result.dynamicColorProvider = color.dynamicColorProvider.map { rawImplement($0, sel, alpha) }
                    guard let provider = color.dynamicAppearanceProvider?.provider else { return result }
                    result.dynamicAppearanceProvider?.provider = { rawImplement(provider($0), sel, alpha) }
                    return result
                }
            }
        }
        
        
        for anyClass in classesToSwizzle + dynamicClassesToSwizzle {
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
                    result.dynamicAppearanceProvider?.provider = { rawImplement(provider($0), sel, alpha) }
                    return result
                }
            }
        }
    }()
    
    var dynamicColorProvider: UIColor? {
        get { Associator(self).getAssociated("dynamicColorProvider") }
        set { Associator(self).setAssociated("dynamicColorProvider", newValue) }
    }
    
}
