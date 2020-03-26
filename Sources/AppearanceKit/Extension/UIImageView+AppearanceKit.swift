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
        let appearance = ap
        update(to: appearance, _dynamicImage) { image = $0 }
    }
}

extension UIImageView {
    static let swizzleImageForAppearanceOne: Void = {
        swizzle(selector: #selector(setter: image), to: #selector(__setImage(_:)))
        swizzle(selector: #selector(UIImageView.init(image:)), to: #selector(__init(image:)))
    }()
    
    @objc func __init(image: UIImage?) -> UIImageView {
        if image?.dynamicColorProvider != nil {
            _dynamicImage = image
        }
        return __init(image: image)
    }
    
    @objc func __setImage(_ image: UIImage?) {
        _dynamicImage = image?.dynamicColorProvider != nil ? image : nil
        __setImage(image)
    }
    
    var _dynamicImage: UIImage? {
        get { getAssociated(\UIImageView._dynamicImage) }
        set { setAssociated(\UIImageView._dynamicImage, newValue) }
    }
}

