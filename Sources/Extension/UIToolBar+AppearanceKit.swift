//
//  UIToolBar+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIToolbar {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        update(to: appearance, &barTintColor)
        items?.forEach { update(to: appearance, &$0.image) }
    }
}
