//
//  UIBarButtonItem+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/17.
//

import UIKit

extension UIBarButtonItem {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        update(to: currentAppearance, &tintColor)
    }
}
