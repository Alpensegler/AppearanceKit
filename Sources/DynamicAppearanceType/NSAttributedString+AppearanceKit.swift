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
            guard let attachment = (dict[.attachment] as? NSTextAttachment)?.resolved(for: appearance) else { return }
            result.addAttributes([.attachment: attachment], range: range)
        }
        result.endEditing()
        return result
    }
}

extension NSAttributedString: DynamicProvidableAppearanceType {
    var dynamicProvider: DynamicProvider<NSAttributedString>? {
        get { getAssociated(\NSAttributedString.dynamicProvider) }
        set { setAssociated(\NSAttributedString.dynamicProvider, newValue) }
    }
    
    var containsDynamicAttachment: Bool {
        get { getAssociated(\NSAttributedString.containsDynamicAttachment) }
        set { setAssociated(\NSAttributedString.containsDynamicAttachment, newValue) }
    }
    
    var resloved: NSAttributedString? {
        dynamicProvider != nil || containsDynamicAttachment ? self : nil
    }
}

extension NSMutableAttributedString {
    static let swizzleForAppearanceOne: Void = {
        guard let anyClass = NSClassFromString("NSConcreteMutableAttributedString") else { return }
        swizzle(classType: anyClass.self, selector: #selector(append(_:)), to: #selector(__append(_:)))
        swizzle(classType: anyClass.self, selector: #selector(addAttributes(_:range:)), to: #selector(__addAttributes(_:range:)))
        swizzle(classType: anyClass.self, selector: #selector(addAttribute(_:value:range:)), to: #selector(__addAttribute(_:value:range:)))
        swizzle(classType: anyClass.self, selector: #selector(setAttributes(_:range:)), to: #selector(__setAttributes(_:range:)))
        swizzle(classType: anyClass.self, selector: #selector(setAttributedString(_:)), to: #selector(__setAttributedString(_:)))
        swizzle(classType: anyClass.self, selector: #selector(insert(_:at:)), to: #selector(__insert(_:at:)))
    }()
    
    @objc func __addAttributes(_ attrs: [NSAttributedString.Key : Any] = [:], range: NSRange) {
        __addAttributes(attrs, range: range)
        if let attachment = attrs[.attachment] as? NSTextAttachment {
            containsDynamicAttachment = containsDynamicAttachment || attachment.isDynamic
        }
    }
    
    @objc func __addAttribute(_ name: NSAttributedString.Key, value: Any, range: NSRange) {
        __addAttribute(name, value: value, range: range)
        if name == .attachment, let attachment = value as? NSTextAttachment {
            containsDynamicAttachment = containsDynamicAttachment || attachment.isDynamic
        }
    }
    
    @objc func __setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        __setAttributes(attrs, range: range)
        if let attachment = attrs?[.attachment] as? NSTextAttachment {
            containsDynamicAttachment = containsDynamicAttachment || attachment.isDynamic
        }
    }
    
    @objc func __append(_ attributedString: NSAttributedString) {
        __append(attributedString)
        containsDynamicAttachment = containsDynamicAttachment || attributedString.containsDynamicAttachment
    }
    
    @objc func __setAttributedString(_ attrString: NSAttributedString) {
        __setAttributedString(attrString)
        containsDynamicAttachment = containsDynamicAttachment || attrString.containsDynamicAttachment
    }
    
    @objc func __insert(_ attrString: NSAttributedString, at loc: Int) {
        __insert(attrString, at: loc)
        containsDynamicAttachment = containsDynamicAttachment || attrString.containsDynamicAttachment
    }
}

