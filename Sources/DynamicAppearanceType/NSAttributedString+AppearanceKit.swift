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
            if let attachment = dict[.attachment] as? NSTextAttachment {
                guard let resolvedAttachment = attachment.resolved(for: appearance), attachment !== resolvedAttachment else { return }
                result.addAttributes([.attachment: resolvedAttachment], range: range)
            } else if let color = dict[.foregroundColor] as? UIColor {
                guard let resolvedColor = color.resolved(for: appearance) ?? color.resloved, resolvedColor !== color else { return }
                result.addAttributes([.foregroundColor: resolvedColor], range: range)
            }
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
            if let attachment = dict[.attachment] as? NSTextAttachment, attachment.isDynamic {
                containsDynamicAttachment = true
                stop.pointee = true
            }
            if let color = dict[.foregroundColor] as? UIColor, color.dynamicProvider != nil {
                containsDynamicAttachment = true
                stop.pointee = true
            }
        }
    }
}

