//
//  UITextView+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UITextView {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        indicatorStyle = appearance.isUserInterfaceDark ? .black : .default
        update(to: appearance, __dynamicAttributedText, __attributedText(_:))
        setNeedsDisplay()
    }
}

extension UITextView {
    static let swizzleTextViewForAppearanceOne: Void = {
        swizzle(selector: #selector(setter: attributedText), to: #selector(__attributedText(_:)))
    }()
    
    @objc func __attributedText(_ attr: NSAttributedString!) {
        attr?.configContainsDynamicAttachment()
        setDynamicValue(attr, store: &__dynamicAttributedText, setter: __attributedText(_:))
    }

    var __dynamicAttributedText: NSAttributedString? {
        get { getAssociated(\.__dynamicAttributedText) }
        set { setAssociated(\.__dynamicAttributedText, newValue) }
    }
}
