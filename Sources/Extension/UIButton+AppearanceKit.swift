//
//  UIButton+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIButton {
    static let swizzleButtonForAppearanceOne: Void = {
        swizzle(selector: #selector(setTitleColor), to: #selector(__setTitleTextColor))
        swizzle(selector: #selector(setImage), to: #selector(__setImage))
    }()
    
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        [State.normal, .highlighted, .disabled, .selected, .focused].forEach { state in
            update(to: appearance, _dynamicTextColor[state.rawValue]) { __setTitleTextColor($0, for: state) }
            update(to: appearance, _dynamicImage[state.rawValue]) { __setImage($0, for: state) }
        }
    }
    
    @objc func __setTitleTextColor(_ color: UIColor?, for state: State) {
        setDynamicValue(color, store: &_dynamicTextColor[state.rawValue]) {
            __setTitleTextColor($0, for: state)
        }
    }
    
    @objc func __setImage(_ image: UIImage?, for state: State) {
        setDynamicValue(image, store: &_dynamicImage[state.rawValue]) {
            __setImage($0, for: state)
        }
    }
    
    var _dynamicTextColor: [UInt: UIColor] {
        get { getAssociated(\._dynamicTextColor) }
        set { setAssociated(\._dynamicTextColor, newValue) }
    }
    
    var _dynamicImage: [UInt: UIImage] {
        get { getAssociated(\._dynamicImage) }
        set { setAssociated(\._dynamicImage, newValue) }
    }
}
