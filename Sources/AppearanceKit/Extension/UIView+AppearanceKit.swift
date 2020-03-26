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
        update(to: appearance, _dynamicBackgroundColor) { backgroundColor = $0 }
        update(to: appearance, _dynamicTintColor) { tintColor = $0 }
    }
}

extension UIView {
    static let swizzleForAppearanceOne: Void = {
        swizzle(selector: #selector(traitCollectionDidChange(_:)), to: #selector(_traitCollectionDidChange(_:)))
        swizzle(selector: #selector(addSubview(_:)), to: #selector(__addSubview(_:)))
        swizzle(selector: #selector(willMove(toWindow:)), to: #selector(__willMoveTo(_:)))
        swizzle(selector: #selector(setter: backgroundColor), to: #selector(__setBackgroundColor(_:)))
        swizzle(selector: #selector(setter: tintColor), to: #selector(__setTintColor(_:)))
    }()
    
    @objc func _traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        _traitCollectionDidChange(previousTraitCollection)
        layer.ap.updateWithTraitCollection(traitCollection)
        ap.updateWithTraitCollection(traitCollection)
    }
    
    @objc func __addSubview(_ view: UIView) {
        __addSubview(view)
        let appearance = ap
        for (key, trait) in appearance.changingTrait where trait.environment.throughHierarchy {
            view.ap.update(trait, key: key)
        }
    }
    
    @objc func __willMoveTo(_ window: UIWindow?) {
        __willMoveTo(window)
        guard window != nil else { return }
        configureAppearance()
        layer.ap.updateWithTraitCollection(traitCollection)
        ap.updateWithTraitCollection(traitCollection)
    }
    
    @objc func __setBackgroundColor(_ color: UIColor?) {
        __setBackgroundColor(color)
        if color?.dynamicColorProvider != nil {
            _dynamicBackgroundColor = color
        }
    }
    
    @objc func __setTintColor(_ color: UIColor!) {
        __setTintColor(color)
        if color?.dynamicColorProvider != nil {
            _dynamicTintColor = color
        }
    }
    
    var _dynamicBackgroundColor: UIColor? {
        get { getAssociated(\UIView._dynamicBackgroundColor) }
        set { setAssociated(\UIView._dynamicBackgroundColor, newValue) }
    }
    
    var _dynamicTintColor: UIColor? {
        get { getAssociated(\UIView._dynamicTintColor) }
        set { setAssociated(\UIView._dynamicTintColor, newValue) }
    }
}
