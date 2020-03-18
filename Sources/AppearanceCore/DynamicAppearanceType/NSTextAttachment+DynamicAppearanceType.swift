//
//  NSTextAttachment+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/18.
//

import UIKit

extension NSTextAttachment: DynamicAppearanceType {
    public func resolved(for appearance: Appearance) -> NSTextAttachment? {
        let resolved = _resolved(for: appearance)
        let attachment = resolved ?? self
        guard let resolvedImage = attachment.image?.resolved(for: appearance) else {
            return resolved?._addingProvider(dynamicAppearanceProvider)
        }
        let result = NSTextAttachment()
        result.contents = attachment.contents
        result.fileType = attachment.fileType
        result.fileWrapper = attachment.fileWrapper
        result.bounds = attachment.bounds
        result.image = resolvedImage
        return result._addingProvider(dynamicAppearanceProvider)
    }
}
