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
        swizzle(selector: #selector(viewDidLoad), to: #selector(__viewDidLoad))
    }()
    
    @objc override func configureAppearanceChange() {
        configureAppearance()
        _updateAppearance(traits: traits.changingTrait, exceptSelf: true, configView: true)
    }
    
    @objc func __traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        __traitCollectionDidChange(previousTraitCollection)
        if ap.didConfigureOnce { _updateAppearance() }
    }
    
    @objc func __didMove(toParent: UIViewController?) {
        __didMove(toParent: toParent)
        guard let parent = toParent, parent.ap.didConfigureOnce else { return }
        guard isViewLoaded else {
            _didMoveToParentWithoutConfig = true
            return
        }
        _updateAppearance(traits: parent.traits.traits, configOnceIfNeeded: true)
    }
    
    @objc func __viewDidLoad() {
        __viewDidLoad()
        guard _didMoveToParentWithoutConfig, let parent = parent, parent.ap.didConfigureOnce else { return }
        _updateAppearance(traits: parent.traits.traits, configOnceIfNeeded: true)
        _didMoveToParentWithoutConfig = false
    }
    
    func _updateAppearance(traits: [Int: Traits<Void>.Value]? = nil, exceptSelf: Bool = false, configOnceIfNeeded: Bool = false, configView: Bool = false) {
        if !exceptSelf { ap.update(traits: traits, traitCollection: traitCollection, configOnceIfNeeded: configOnceIfNeeded) }
        guard let traits = traits else { return }
        presentedViewController?._updateAppearance(traits: traits, configOnceIfNeeded: configOnceIfNeeded, configView: configView)
        children.forEach { $0._updateAppearance(traits: traits, configOnceIfNeeded: configOnceIfNeeded, configView: configView) }
        if isViewLoaded, configView { view._updateAppearance(traits: traits, configOnceIfNeeded: configOnceIfNeeded) }
    }

    var _didMoveToParentWithoutConfig: Bool {
        get { getAssociated(\._didMoveToParentWithoutConfig) }
        set { setAssociated(\._didMoveToParentWithoutConfig, newValue) }
    }
}
