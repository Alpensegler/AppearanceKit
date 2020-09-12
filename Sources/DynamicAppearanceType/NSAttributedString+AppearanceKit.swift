//
//  NSAttributedString+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/18.
//

import UIKit

public extension NSAttributedString {
    static func bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> NSAttributedString
    ) -> NSAttributedString {
        _bindEnvironment(keyPath, by: provider)
    }
    
    func resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> NSAttributedString? {
        if let resolved = _resolved(for: appearance) { return resolved }
        guard containsDynamicAttachment, let result = mutableCopy() as? NSMutableAttributedString else {
            return nil
        }
        
        result.containsDynamicAttachment = containsDynamicAttachment
        result.beginEditing()
        enumerateAttributes(in: NSRange(location: 0, length: length), options: .longestEffectiveRangeNotRequired) { (dict, range, _) in
            guard let attachment = dict[.attachment] as? NSTextAttachment else { return }
            guard let resolvedAttachment = attachment.resolved(for: appearance), attachment !== resolvedAttachment else { return }
            result.addAttributes([.attachment: resolvedAttachment], range: range)
        }
        result.endEditing()
        return result
    }
}

extension NSAttributedString: DynamicProvidableAppearanceType {
    var dynamicProvider: DynamicProvider<NSAttributedString>? {
        get { getAssociated(\.dynamicProvider) }
        set { setAssociated(\.dynamicProvider, newValue) }
    }
    
    var containsDynamicAttachment: Bool {
        get { getAssociated(\.containsDynamicAttachment) }
        set { setAssociated(\.containsDynamicAttachment, newValue) }
    }
    
    var resloved: NSAttributedString? {
        dynamicProvider != nil || containsDynamicAttachment ? self : nil
    }
    
    func configContainsDynamicAttachment() {
        enumerateAttributes(in: NSRange(location: 0, length: length), options: .longestEffectiveRangeNotRequired) { (dict, range, stop) in
            guard let attachment = dict[.attachment] as? NSTextAttachment, attachment.isDynamic else { return }
            containsDynamicAttachment = true
            stop.pointee = true
        }
    }
}

