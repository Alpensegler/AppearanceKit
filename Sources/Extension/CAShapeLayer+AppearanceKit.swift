//
//  CAShapeLayer+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/17.
//

import UIKit

extension CAShapeLayer {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        update(to: appearance, &fillColor)
        update(to: appearance, &strokeColor)
    }
}

