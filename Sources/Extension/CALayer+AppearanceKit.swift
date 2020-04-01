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
        update(to: appearance, &backgroundColor)
        update(to: appearance, &borderColor)
        update(to: appearance, &shadowColor)
    }
}

extension CALayer {
    static let swizzleForAppearanceOne: Void = {
        swizzle(selector: #selector(addSublayer(_:)), to: #selector(__addSublayer(_:)))
    }()
    
    @objc override func configureAppearanceChange() {
        configureAppearance()
        _updateAppearance(traits: traits.changingTrait, exceptSelf: true)
    }
    
    @objc func __addSublayer(_ layer: CALayer) {
        __addSublayer(layer)
        guard let traitCollection = ap.traitCollection else { return }
        layer._updateAppearance(traits: traits.traits, traitCollection, configOnceIfNeeded: true)
    }
    
    func _updateAppearance(
        traits: [Int: Traits<Void>.Value]? = nil,
        _ traitCollection: UITraitCollection? = nil,
        exceptSelf: Bool = false,
        configOnceIfNeeded: Bool = false
    ) {
        if !exceptSelf { ap.update(traits: traits, traitCollection: traitCollection, configOnceIfNeeded: configOnceIfNeeded) }
        sublayers?.filter { $0.delegate != nil }.forEach {
            $0._updateAppearance(traits: traits, traitCollection)
        }
    }
}
