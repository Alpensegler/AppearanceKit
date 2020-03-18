//
//  UIImageView+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIImageView {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = currentAppearance
        update(to: appearance, &image)
    }
}

