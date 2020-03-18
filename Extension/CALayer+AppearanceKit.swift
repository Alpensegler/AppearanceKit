//
//  CALayer+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/15.
//

import UIKit

extension CALayer: AppearanceCollection {
    open var currentAppearance: Appearance {
        get {
            appearance ?? {
                guard let appearance = (delegate as? UIView)?.currentAppearance else {
                    fatalError("appearance for layer without view is not supported")
                }
                self.appearance = appearance
                return appearance
            }()
        }
        set {
            update(to: newValue)
        }
    }
    
    @objc open func configureAppearance() {
        appearance?.attributesStorage.configForUpdate()
        let appearance = currentAppearance
        for sublayer in sublayers ?? [] where sublayer.delegate == nil {
            sublayer.update(to: currentAppearance, withTraitCollection: true)
        }
        setNeedsLayout()
        setNeedsDisplay()
        Appearance.current = appearance
        update(to: appearance, &backgroundColor)
        update(to: appearance, &borderColor)
        update(to: appearance, &shadowColor)
    }
}
