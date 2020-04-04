//
//  UIImageView+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIImageView {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        update(to: ap, _dynamicImage, __setImage(_:))
    }
}

extension UIImageView {
    static let swizzleImageForAppearanceOne: Void = {
        swizzle(selector: #selector(traitCollectionDidChange(_:)), to: #selector(__traitCollectionDidChange))
        swizzle(selector: #selector(setter: image), to: #selector(__setImage(_:)))
        swizzle(selector: #selector(UIImageView.init(image:)), to: #selector(__init(image:)))
    }()

    @objc func __traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        __traitCollectionDidChange(previousTraitCollection)
        if ap.didConfigureOnce { _updateAppearance() }
    }
    
    @objc func __init(image: UIImage?) -> UIImageView {
        if image?.dynamicProvider != nil {
            _dynamicImage = image
        }
        return __init(image: image)
    }
    
    @objc func __setImage(_ image: UIImage?) {
        setDynamicValue(image, store: &_dynamicImage, setter: __setImage(_:))
    }
    
    var _dynamicImage: UIImage? {
        get { getAssociated(\._dynamicImage) }
        set { setAssociated(\._dynamicImage, newValue) }
    }
}

