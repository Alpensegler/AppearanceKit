//
//  UIView+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

extension UIView: AppearanceTraitCollection {
    @objc open func configureAppearance() {
        let appearance = ap
        for (key, trait) in appearance.changingTrait {
            layer.ap.update(trait, key: key)
            guard trait.environment.throughHierarchy else { continue }
            subviews.forEach { $0.ap.update(trait, key: key) }
        }
        setNeedsLayout()
        setNeedsDisplay()
        update(to: appearance, &backgroundColor)
        update(to: appearance, &tintColor)
    }
}

extension UIView {
    static let swizzleForAppearanceOne: Void = {
        swizzle(selector: #selector(traitCollectionDidChange(_:)), to: #selector(_traitCollectionDidChange(_:)))
        swizzle(selector: #selector(willMove(toWindow:)), to: #selector(__willMove))
    }()
    
    @objc func _traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        _traitCollectionDidChange(previousTraitCollection)
        layer.ap.traitCollection = ap.traitCollection
        ap.updateWithTraitCollection(traitCollection)
    }
    
    @objc func __willMove(toWindow newWindow: UIWindow?) {
        __willMove(toWindow: newWindow)
    }
}

