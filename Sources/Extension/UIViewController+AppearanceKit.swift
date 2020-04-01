//
//  UIViewController+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/17.
//

import UIKit

extension UIViewController: AppearanceEnvironment {
    @objc open func configureAppearance() {
        let appearance = ap
        appearance.setConfigureOnce()
        appearance.setTraitCollection(traitCollection)
    }
}

extension UIViewController {
    static let swizzleForAppearanceOne: Void = {
        swizzle(selector: #selector(traitCollectionDidChange(_:)), to: #selector(__traitCollectionDidChange(_:)))
        swizzle(selector: #selector(didMove(toParent:)), to: #selector(__didMove(toParent:)))
    }()
    
    @objc override func configureAppearanceChange() {
        configureAppearance()
        _updateAppearance(traits: traits.changingTrait, exceptSelf: true)
    }
    
    @objc func __traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        __traitCollectionDidChange(previousTraitCollection)
        if ap.didConfigureOnce { _updateAppearance() }
    }
    
    @objc func __didMove(toParent: UIViewController?) {
        __didMove(toParent: toParent)
        guard let parent = toParent else { return }
        _updateAppearance(traits: parent.traits.traits, configOnceIfNeeded: true)
    }
    
    func _updateAppearance(traits: [Int: Traits<Void>.Value]? = nil, exceptSelf: Bool = false, configOnceIfNeeded: Bool = false) {
        if !exceptSelf { ap.update(traits: traits, traitCollection: traitCollection, configOnceIfNeeded: configOnceIfNeeded) }
        guard let traits = traits else { return }
        presentedViewController?._updateAppearance(traits: traits, configOnceIfNeeded: configOnceIfNeeded)
        children.forEach { $0._updateAppearance(traits: traits, configOnceIfNeeded: configOnceIfNeeded) }
        if isViewLoaded {
            view._updateAppearance(traits: traits)
        }
    }
}
