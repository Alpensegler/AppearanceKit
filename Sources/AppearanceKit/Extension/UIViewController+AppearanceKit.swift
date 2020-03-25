//
//  UIViewController+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/17.
//

import UIKit

extension UIViewController: AppearanceTraitCollection {
    @objc open func configureAppearance() {
        setNeedsStatusBarAppearanceUpdate()
        let appearance = ap
        for (key, trait) in appearance.changingTrait where trait.environment.throughHierarchy {
            presentedViewController?.ap.update(trait, key: key)
            children.forEach { $0.ap.update(trait, key: key) }
            if isViewLoaded {
                view.ap.update(trait, key: key)
            }
        }
    }
}

extension UIViewController {
    static let swizzleForAppearanceOne: Void = {
        swizzle(selector: #selector(traitCollectionDidChange(_:)), to: #selector(_traitCollectionDidChange(_:)))
        swizzle(selector: #selector(addChild(_:)), to: #selector(__addChild(_:)))
    }()
    
    @objc func _traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        _traitCollectionDidChange(previousTraitCollection)
        ap.updateWithTraitCollection(traitCollection)
    }
    
    @objc func __addChild(_ childController: UIViewController) {
        __addChild(childController)
        let appearance = ap
        for (key, trait) in appearance.changingTrait where trait.environment.throughHierarchy {
            childController.ap.update(trait, key: key)
        }
    }
}
