//
//  UIButton+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIButton {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        [State.normal, .highlighted, .disabled, .selected, .focused].forEach { state in
            update(to: appearance, titleColor(for: state)) { setTitleColor($0, for: state) }
            update(to: appearance, titleShadowColor(for: state)) { setTitleShadowColor($0, for: state) }
            update(to: appearance, image(for: state)) { setImage($0, for: state) }
            update(to: appearance, backgroundImage(for: state)) { setBackgroundImage($0, for: state) }
        }
    }
}
