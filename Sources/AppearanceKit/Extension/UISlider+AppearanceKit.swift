//
//  UISlider+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UISlider {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        update(to: appearance, &maximumTrackTintColor)
        update(to: appearance, &minimumTrackTintColor)
    }
}

