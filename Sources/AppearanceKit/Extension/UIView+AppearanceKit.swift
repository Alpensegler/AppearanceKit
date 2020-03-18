//
//  UIView+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

extension UIView: AppearanceCollection {
    open var currentAppearance: Appearance {
        get { _currentAppearance }
        set { _currentAppearance = newValue }
    }
    
    @objc open func configureAppearance() {
        appearance?.attributesStorage.configForUpdate()
        appearance?.traitCollection = traitCollection
        let appearance = currentAppearance
        if !currentAppearance.configCurrentOnly {
            subviews.forEach { $0.update(to: appearance) }
        }
        layer.update(to: appearance, withTraitCollection: true)
        setNeedsLayout()
        setNeedsDisplay()
        Appearance.current = appearance
        update(to: appearance, &backgroundColor)
        update(to: appearance, &tintColor)
    }
}

extension UIView {
    static let swizzleForAppearanceOne: Void = {
        UIView.swizzle(selector: #selector(traitCollectionDidChange(_:)), to: #selector(_traitCollectionDidChange(_:)))
        UIView.swizzle(selector: #selector(willMove(toWindow:)), to: #selector(__willMove))
    }()
    
    @objc func _traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        _traitCollectionDidChange(previousTraitCollection)
        var appearance = currentAppearance
        appearance.configCurrentOnly = true
        self.appearance = appearance
        configureAppearance()
        self.appearance?.configCurrentOnly = false
    }
    
    @objc func __willMove(toWindow newWindow: UIWindow?) {
        __willMove(toWindow: newWindow)
        guard newWindow != nil else { return }
        var appearance = currentAppearance
        appearance.configCurrentOnly = true
        self.appearance = appearance
        configureAppearance()
        self.appearance?.configCurrentOnly = false
    }
}

