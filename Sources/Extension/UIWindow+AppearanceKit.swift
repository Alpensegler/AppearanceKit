//
//  UIWindow+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIWindow {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        for (key, trait) in appearance.changingTrait where trait.environment.throughHierarchy {
            rootViewController?.ap.update(trait, key: key)
        }
    }
}
