//
//  UILabel+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UILabel {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        update(to: appearance, &textColor)
        update(to: appearance, &highlightedTextColor)
        update(to: appearance, &attributedText)
    }
}
