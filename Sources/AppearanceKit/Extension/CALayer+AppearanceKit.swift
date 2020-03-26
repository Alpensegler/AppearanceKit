//
//  CALayer+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/15.
//

import UIKit

extension CALayer: AppearanceTraitCollection {
    @objc open func configureAppearance() {
        let appearance = ap
        for (key, trait) in appearance.changingTrait {
            sublayers?.filter { $0.delegate != nil }.forEach {
                $0.ap.update(trait, key: key)
            }
        }
        update(to: appearance, &backgroundColor)
        update(to: appearance, &borderColor)
        update(to: appearance, &shadowColor)
    }
}

extension CALayer {
    static let swizzleForAppearanceOne: Void = {
        swizzle(selector: #selector(addSublayer(_:)), to: #selector(__addSublayer(_:)))
    }()
    
    @objc func __addSublayer(_ layer: CALayer) {
        __addSublayer(layer)
        guard layer.delegate == nil else { return }
        let appearance = ap
        for (key, trait) in appearance.changingTrait where trait.environment.throughHierarchy {
            layer.ap.update(trait, key: key)
        }
    }
}
