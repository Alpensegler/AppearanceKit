//
//  UIViewController+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/17.
//

import UIKit

extension UIViewController: AppearanceCollection {
    open var currentAppearance: Appearance {
        get { _currentAppearance }
        set { _currentAppearance = newValue }
    }
    
    @objc open func configureAppearance() {
        appearance?.attributesStorage.configForUpdate()
        appearance?.traitCollection = traitCollection
        setNeedsStatusBarAppearanceUpdate()
        if !currentAppearance.configCurrentOnly {
            let appearance = currentAppearance
            presentedViewController?.update(to: appearance)
            children.forEach { $0.update(to: appearance) }
            if isViewLoaded { view.update(to: appearance) }
        }
        Appearance.current = appearance
    }
}
