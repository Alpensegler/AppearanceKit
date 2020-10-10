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
        update(to: appearance, _dynamicTextColor, __setTextColor)
        update(to: appearance, _dynamicHighlightedTextColor, __setHighlightedTextColor)
        update(to: appearance, _dynamicAttributedText, __setAttributedText)
        setNeedsDisplay()
    }
}

extension UILabel {
    static let swizzleLabelForAppearanceOne: Void = {
        swizzle(selector: #selector(traitCollectionDidChange(_:)), to: #selector(__traitCollectionDidChange))
        swizzle(selector: #selector(setter: attributedText), to: #selector(__setAttributedText))
        swizzle(selector: #selector(setter: textColor), to: #selector(__setTextColor))
        swizzle(selector: #selector(setter: highlightedTextColor), to: #selector(__setHighlightedTextColor))
    }()

    @objc func __traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        __traitCollectionDidChange(previousTraitCollection)
        if ap.didConfigureOnce { _updateAppearance() }
    }
    
    @objc func __setTextColor(_ color: UIColor?) {
        setDynamicValue(color, store: &_dynamicTextColor, setter: __setTextColor(_:))
    }

    @objc func __setHighlightedTextColor(_ color: UIColor!) {
        setDynamicValue(color, store: &_dynamicHighlightedTextColor, setter: __setHighlightedTextColor(_:))
    }
    
    @objc func __setAttributedText(_ attr: NSAttributedString?) {
        attr?.configContainsDynamicAttachment()
        setDynamicValue(attr, store: &_dynamicAttributedText, setter: __setAttributedText(_:))
    }

    var _dynamicAttributedText: NSAttributedString? {
        get { getAssociated(\._dynamicAttributedText) }
        set { setAssociated(\._dynamicAttributedText, newValue) }
    }
    
    var _dynamicTextColor: UIColor? {
        get { getAssociated(\._dynamicTextColor) }
        set { setAssociated(\._dynamicTextColor, newValue) }
    }

    var _dynamicHighlightedTextColor: UIColor? {
        get { getAssociated(\._dynamicHighlightedTextColor) }
        set { setAssociated(\._dynamicHighlightedTextColor, newValue) }
    }
}
