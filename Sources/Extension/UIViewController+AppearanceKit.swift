//
//  UIViewController+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/17.
//

import UIKit

extension UIViewController: AppearanceEnvironment {
    public var onAppearanceChanged: (() -> Void)? {
        get { getAssociated("AppearanceKit.onAppearanceChanged") }
        set { setAssociated("AppearanceKit.onAppearanceChanged", newValue) }
    }
    
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
        let config: (UIViewController) -> Void = {
            $0.configAppearanceAndTriggerOnchanged()
            $0._updateAppearance(traits: $0.traits.changingTrait, exceptSelf: true, configView: true)
        }
        if isViewLoaded {
            config(self)
        } else {
            _appendToStagingConfig(config: config)
        }
    }
    
    @objc func __traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        __traitCollectionDidChange(previousTraitCollection)
        if ap.didConfigureOnce { _updateAppearance() }
    }
    
    @objc func __didMove(toParent: UIViewController?) {
        __didMove(toParent: toParent)
        guard let parent = toParent, parent.ap.didConfigureOnce else { return }
        _updateAppearance(traits: parent.traits.traits, configOnceIfNeeded: true)
    }
    
    @objc func __viewDidLoad() {
        __viewDidLoad()
        guard let configs = _stagingConfigs else { return }
        configs.forEach { $0(self) }
        _stagingConfigs = nil
    }
    
    func _updateAppearance(traits: [Int: Traits<Void>.Value]? = nil, exceptSelf: Bool = false, configOnceIfNeeded: Bool = false, configView: Bool = false) {
        guard isViewLoaded else {
            _appendToStagingConfig { $0._updateAppearance(traits: traits, exceptSelf: exceptSelf, configOnceIfNeeded: configOnceIfNeeded, configView: configView) }
            return
        }
        if !exceptSelf { ap.update(traits: traits, traitCollection: traitCollection, configOnceIfNeeded: configOnceIfNeeded) }
        guard let traits = traits else { return }
        presentedViewController?._updateAppearance(traits: traits, configOnceIfNeeded: configOnceIfNeeded)
        children.forEach { $0._updateAppearance(traits: traits, configOnceIfNeeded: configOnceIfNeeded) }
        if configView { view._updateAppearance(traits: traits, configOnceIfNeeded: configOnceIfNeeded) }
    }
    
    func _appendToStagingConfig(config: @escaping (UIViewController) -> Void) {
        var configs = _stagingConfigs ?? []
        configs.append(config)
        _stagingConfigs = configs
        return
    }

    var _stagingConfigs: [(UIViewController) -> Void]? {
        get { getAssociated(\._stagingConfigs) }
        set { setAssociated(\._stagingConfigs, newValue) }
    }
}
