//
//  UIBarItem+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/17.
//

import UIKit

extension UIBarItem: AppearanceCollection {
    open var currentAppearance: Appearance {
        get { appearance! }
        set { appearance = newValue }
    }
    
    @objc open func configureAppearance() {
        appearance?.attributesStorage.configForUpdate()
        let appearance = currentAppearance
        Appearance.current = appearance
        update(to: appearance, &image)
    }
}
