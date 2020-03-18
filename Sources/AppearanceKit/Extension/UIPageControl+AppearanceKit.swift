//
//  UIPageControl+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIPageControl {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = currentAppearance
        update(to: appearance, &pageIndicatorTintColor)
        update(to: appearance, &currentPageIndicatorTintColor)
    }
}

