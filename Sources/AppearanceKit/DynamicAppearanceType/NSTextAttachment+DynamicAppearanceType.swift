//
//  NSTextAttachment+DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/18.
//

import UIKit

extension NSTextAttachment: DynamicAppearanceType {
    public func customResolved<Base>(for appearance: Appearance<Base>) -> NSTextAttachment? {
        guard let resolvedImage = image?.resolved(for: appearance) else { return nil }
        let result = NSTextAttachment()
        result.contents = contents
        result.fileType = fileType
        result.fileWrapper = fileWrapper
        result.bounds = bounds
        result.image = resolvedImage
        return result
    }
}
