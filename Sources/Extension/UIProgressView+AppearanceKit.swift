//
//  UIProgressView+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIProgressView {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        update(to: appearance, &progressTintColor)
        update(to: appearance, &trackTintColor)
    }
}

