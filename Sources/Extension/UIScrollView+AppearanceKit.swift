//
//  UIScrollView+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIScrollView {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        indicatorStyle = ap.isUserInterfaceDark ? .black : .default
    }
}

