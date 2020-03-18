//
//  UITabBarItem+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/17.
//

import UIKit

extension UITabBarItem {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        update(to: currentAppearance, &selectedImage)
    }
}
