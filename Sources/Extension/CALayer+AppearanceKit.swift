//
//  CALayer+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/15.
//

import UIKit

extension CALayer: AppearanceEnvironment {
    @objc open func configureAppearance() {
        let appearance = ap
        appearance.setConfigureOnce()
        appearance.setTraitCollection((delegate as? UIView)?.traitCollection)
        update(to: appearance, _dynamicBackgroundColor, __backgroundColor(_:))
        update(to: appearance, _dynamicBorderColor, __borderColor(_:))
        update(to: appearance, _dynamicShadowColor, __shadowColor(_:))
    }
}

extension CALayer {
    static let swizzleForAppearanceOne: Void = {
        swizzle(selector: #selector(addSublayer(_:)), to: #selector(__addSublayer(_:)))
        swizzle(selector: #selector(setter: backgroundColor), to: #selector(__backgroundColor))
        swizzle(selector: #selector(setter: borderColor), to: #selector(__borderColor))
        swizzle(selector: #selector(setter: shadowColor), to: #selector(__shadowColor))
    }()
    
    @objc override func configureAppearanceChange() {
        configureAppearance()
        _updateAppearance(traits: traits.changingTrait, exceptSelf: true)
    }
    
    @objc func __addSublayer(_ layer: CALayer!) {
        __addSublayer(layer)
        guard let traitCollection = ap.traitCollection, ap.didConfigureOnce else { return }
        layer?._updateAppearance(traits: traits.traits, traitCollection, configOnceIfNeeded: true)
    }
    
    func _updateAppearance(
        traits: [Int: Traits<Void>.Value]? = nil,
        _ traitCollection: UITraitCollection? = nil,
        exceptSelf: Bool = false,
        configOnceIfNeeded: Bool = false
    ) {
        if !exceptSelf { ap.update(traits: traits, traitCollection: traitCollection, configOnceIfNeeded: configOnceIfNeeded) }
        sublayers?.filter { $0.delegate == nil }.forEach {
            $0._updateAppearance(traits: traits, traitCollection, configOnceIfNeeded: configOnceIfNeeded)
        }
    }
    
    @objc func __backgroundColor(_ backgroundColor: CGColor?) {
        guard let provider = backgroundColor?.dynamicProvider else {
            __backgroundColor(backgroundColor)
            return
        }
        __backgroundColor(provider.resolved)
        _dynamicBackgroundColor = backgroundColor
    }
    
    @objc func __borderColor(_ borderColor: CGColor?) {
        guard let provider = borderColor?.dynamicProvider else {
            __borderColor(borderColor)
            return
        }
        __borderColor(provider.resolved)
        _dynamicBorderColor = borderColor
    }
    
    @objc func __shadowColor(_ shadowColor: CGColor?) {
        guard let provider = shadowColor?.dynamicProvider else {
            __shadowColor(shadowColor)
            return
        }
        __shadowColor(provider.resolved)
        _dynamicShadowColor = shadowColor
    }
    
    var _dynamicBackgroundColor: CGColor? {
        get { Associator(self).getAssociated("AppearanceKit.backgroundColor") }
        set { Associator(self).setAssociated("AppearanceKit.backgroundColor", newValue) }
    }
    
    var _dynamicBorderColor: CGColor? {
        get { Associator(self).getAssociated("AppearanceKit.borderColor") }
        set { Associator(self).setAssociated("AppearanceKit.borderColor", newValue) }
    }
    
    var _dynamicShadowColor: CGColor? {
        get { Associator(self).getAssociated("AppearanceKit.shadowColor") }
        set { Associator(self).setAssociated("AppearanceKit.shadowColor", newValue) }
    }
    
}
