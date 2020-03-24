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
        setNeedsLayout()
        setNeedsDisplay()
        update(to: appearance, &backgroundColor)
        update(to: appearance, &borderColor)
        update(to: appearance, &shadowColor)
    }
}
