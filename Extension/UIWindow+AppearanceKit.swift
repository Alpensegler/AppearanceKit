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
        let appearance = currentAppearance
        if !appearance.configCurrentOnly {
            rootViewController?.update(to: currentAppearance)
        }
    }
}
