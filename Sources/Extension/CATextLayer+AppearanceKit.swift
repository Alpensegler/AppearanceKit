//
//  CATextLayer+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2021/1/8.
//

import UIKit

extension CATextLayer {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        update(to: ap, _dynamicForegroundColor, __foregroundColor(_:))
    }
}

extension CATextLayer {
    static let swizzleTextColorForAppearanceOne: Void = {
        swizzle(selector: #selector(setter: foregroundColor), to: #selector(__foregroundColor))
    }()
    
    @objc func __foregroundColor(_ foregroundColor: CGColor?) {
        setDynamicValue(foregroundColor, store: &_dynamicForegroundColor, setter: __foregroundColor)
    }
    
    var _dynamicForegroundColor: CGColor? {
        get { Associator(self).getAssociated("AppearanceKit.foregroundColor") }
        set { Associator(self).setAssociated("AppearanceKit.foregroundColor", newValue) }
    }
}
