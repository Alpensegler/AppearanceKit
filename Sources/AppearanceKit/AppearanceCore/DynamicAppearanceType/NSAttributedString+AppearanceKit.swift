//
//  NSAttributedString+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/18.
//

import UIKit

extension NSAttributedString: DynamicAppearanceType {
    public func resolved(for appearance: Appearance) -> NSAttributedString? {
        let resolved = _resolved(for: appearance)
        let attributedText = resolved ?? self
        guard let copy = attributedText.mutableCopy() as? NSMutableAttributedString else {
            return resolved?._addingProvider(dynamicAppearanceProvider)
        }
        var hasChange = false
        func addReslovedIfNeeded<T: DynamicAppearanceType>(
            _ dynamicType: T.Type,
            key: NSAttributedString.Key,
            attributes: [NSAttributedString.Key: Any],
            range: NSRange
        ) {
            guard let resolved = (attributes[key] as? T)?.resolved(for: appearance) else { return }
            hasChange = true
            copy.addAttribute(key, value: resolved, range: range)
        }
        copy.beginEditing()
        attributedText.enumerateAttributes(in: NSRange(location: 0, length: length), options: .longestEffectiveRangeNotRequired) { (dict, range, _) in
            addReslovedIfNeeded(UIColor.self, key: .backgroundColor, attributes: dict, range: range)
            addReslovedIfNeeded(UIColor.self, key: .foregroundColor, attributes: dict, range: range)
            addReslovedIfNeeded(UIColor.self, key: .strokeColor, attributes: dict, range: range)
            addReslovedIfNeeded(UIColor.self, key: .underlineColor, attributes: dict, range: range)
            addReslovedIfNeeded(NSTextAttachment.self, key: .attachment, attributes: dict, range: range)
        }
        if !hasChange { return resolved?._addingProvider(dynamicAppearanceProvider) }
        copy.endEditing()
        return (copy as NSAttributedString)._addingProvider(dynamicAppearanceProvider)
    }
}
