//
//  CAGradientLayer+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/17.
//

import UIKit

extension CAGradientLayer {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        guard let colors = colors as? [CGColor] else { return }
        let appearance = currentAppearance
        self.colors = colors.map { $0.resolved(for: appearance) ?? $0 }
    }
}
