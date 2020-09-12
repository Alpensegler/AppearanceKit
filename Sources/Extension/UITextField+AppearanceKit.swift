//
//  UITextField+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UITextField {
    static let swizzleTextFeildForAppearanceOne: Void = {
        swizzle(selector: #selector(setter: attributedText), to: #selector(__setAttributedText))
    }()
    
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        update(to: appearance, &textColor)
        update(to: appearance, _dynamicAttributedText, __setAttributedText)
        setNeedsDisplay()
    }
    
    @objc func __setAttributedText(_ attr: NSAttributedString?) {
        attr?.configContainsDynamicAttachment()
        setDynamicValue(attr, store: &_dynamicAttributedText, setter: __setAttributedText(_:))
    }

    var _dynamicAttributedText: NSAttributedString? {
        get { getAssociated(\._dynamicAttributedText) }
        set { setAssociated(\._dynamicAttributedText, newValue) }
    }
}

