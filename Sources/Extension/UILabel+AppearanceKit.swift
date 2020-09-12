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
        update(to: appearance, _dynamicAttributedText, __setAttributedText)
        setNeedsDisplay()
    }
}

extension UILabel {
    static let swizzleLabelForAppearanceOne: Void = {
        swizzle(selector: #selector(traitCollectionDidChange(_:)), to: #selector(__traitCollectionDidChange))
        swizzle(selector: #selector(setter: attributedText), to: #selector(__setAttributedText))
    }()

    @objc func __traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        __traitCollectionDidChange(previousTraitCollection)
        if ap.didConfigureOnce { _updateAppearance() }
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
