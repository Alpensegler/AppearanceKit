//
//  UIView+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

extension UIView: AppearanceEnvironment {
    @objc open func configureAppearance() {
        let appearance = ap
        appearance.setConfigureOnce()
        appearance.setTraitCollection(traitCollection)
        update(to: appearance, _dynamicBackgroundColor, __setBackgroundColor(_:))
        update(to: appearance, _dynamicTintColor, __setTintColor(_:))
    }
}

extension UIView {
    static let swizzleForAppearanceOne: Void = {
        swizzle(selector: #selector(traitCollectionDidChange(_:)), to: #selector(_traitCollectionDidChange(_:)))
        swizzle(selector: #selector(didMoveToSuperview), to: #selector(__didMoveToSuperView))
        swizzle(selector: #selector(setter: backgroundColor), to: #selector(__setBackgroundColor(_:)))
        swizzle(selector: #selector(setter: tintColor), to: #selector(__setTintColor(_:)))
    }()

    @objc override func configureAppearanceChange() {
        configureAppearance()
        _updateAppearance(traits: traits.changingTrait, exceptSelf: true)
    }

    @objc var viewControllerForUpdate: UIViewController? { nil }

    @objc func _traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        _traitCollectionDidChange(previousTraitCollection)
        if ap.didConfigureOnce { _updateAppearance() }
    }

    @objc func __didMoveToSuperView() {
        __didMoveToSuperView()
        guard let superview = superview, superview.ap.didConfigureOnce else { return }
        _updateAppearance(traits: superview.traits.traits, configOnceIfNeeded: true)
    }

    func _updateAppearance(
        traits: [Int: Traits<Void>.Value]? = nil,
        exceptSelf: Bool = false,
        configOnceIfNeeded: Bool = false
    ) {
        if !exceptSelf { ap.update(traits: traits, traitCollection: traitCollection, configOnceIfNeeded: configOnceIfNeeded) }
        layer._updateAppearance(traits: traits, traitCollection, configOnceIfNeeded: configOnceIfNeeded)
        guard let traits = traits else { return }
        subviews.forEach { $0._updateAppearance(traits: traits, configOnceIfNeeded: configOnceIfNeeded) }
        viewControllerForUpdate?._updateAppearance(traits: traits, configOnceIfNeeded: configOnceIfNeeded)
    }

    @objc func __setBackgroundColor(_ color: UIColor?) {
        if let provider = color?.dynamicProvider {
            __setBackgroundColor(provider.resolved)
            _dynamicBackgroundColor = color
        } else {
            __setBackgroundColor(color)
            _dynamicBackgroundColor = nil
        }
    }

    @objc func __setTintColor(_ color: UIColor!) {
        if let provider = color?.dynamicProvider {
            __setTintColor(provider.resolved)
            _dynamicTintColor = color
        } else {
            __setTintColor(color)
            _dynamicTintColor = nil
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
