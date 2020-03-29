//
//  UITextView+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UITextView {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        indicatorStyle = appearance.isUserInterfaceDark ? .black : .default
        update(to: appearance, &attributedText)
    }
}

