//
//  UITabBar+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UITabBar {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = currentAppearance
        update(to: appearance, &barTintColor)
        items?.forEach { $0.update(to: appearance) }
    }
}

