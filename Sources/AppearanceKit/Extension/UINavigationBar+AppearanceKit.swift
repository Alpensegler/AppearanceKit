//
//  UINavigationBar+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UINavigationBar {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        update(to: ap, &barTintColor)
    }
}

