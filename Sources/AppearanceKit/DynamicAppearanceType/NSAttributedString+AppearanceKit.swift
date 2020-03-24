//
//  NSAttributedString+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/18.
//

import UIKit

extension NSAttributedString: DynamicAppearanceType {
    public func customResolved<Base>(for appearance: Appearance<Base>) -> NSAttributedString? {
        guard let result = mutableCopy() as? NSMutableAttributedString else { return nil }
        var hasChange = false
        func addReslovedIfNeeded<T: DynamicAppearanceType>(
            _ dynamicType: T.Type,
            key: NSAttributedString.Key,
            attributes: [NSAttributedString.Key: Any],
            range: NSRange
        ) {
            guard let resolved = (attributes[key] as? T)?.resolved(for: appearance) else { return }
            hasChange = true
            result.addAttribute(key, value: resolved, range: range)
        }
        result.beginEditing()
        enumerateAttributes(in: NSRange(location: 0, length: length), options: .longestEffectiveRangeNotRequired) { (dict, range, _) in
            addReslovedIfNeeded(UIColor.self, key: .backgroundColor, attributes: dict, range: range)
            addReslovedIfNeeded(UIColor.self, key: .foregroundColor, attributes: dict, range: range)
            addReslovedIfNeeded(UIColor.self, key: .strokeColor, attributes: dict, range: range)
            addReslovedIfNeeded(UIColor.self, key: .underlineColor, attributes: dict, range: range)
            addReslovedIfNeeded(NSTextAttachment.self, key: .attachment, attributes: dict, range: range)
        }
        if !hasChange { return nil }
        result.endEditing()
        return result
    }
}
