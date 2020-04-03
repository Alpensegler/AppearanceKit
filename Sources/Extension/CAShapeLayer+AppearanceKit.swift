//
//  CAShapeLayer+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/17.
//

import UIKit

extension CAShapeLayer {
    @objc open override func configureAppearance() {
        super.configureAppearance()
        let appearance = ap
        update(to: appearance, _dynamicFillColor, __fillColor(_:))
        update(to: appearance, _dynamicStrokeColor, __strokeColor(_:))
    }
}

extension CAShapeLayer {
    static let swizzleShapeColorForAppearanceOne: Void = {
        swizzle(selector: #selector(setter: fillColor), to: #selector(__fillColor))
        swizzle(selector: #selector(setter: strokeColor), to: #selector(__strokeColor))
    }()
    
    @objc func __fillColor(_ fillColor: CGColor?) {
        guard let provider = fillColor?.dynamicProvider else {
            __fillColor(fillColor)
            return
        }
        __fillColor(provider.resolved)
        _dynamicFillColor = fillColor
    }
    
    @objc func __strokeColor(_ strokeColor: CGColor?) {
        guard let provider = strokeColor?.dynamicProvider else {
            __strokeColor(strokeColor)
            return
        }
        __strokeColor(provider.resolved)
        _dynamicStrokeColor = strokeColor
    }
    
    
    var _dynamicFillColor: CGColor? {
        get { Associator(self).getAssociated("AppearanceKit.fillColor") }
        set { Associator(self).setAssociated("AppearanceKit.fillColor", newValue) }
    }
    
    var _dynamicStrokeColor: CGColor? {
        get { Associator(self).getAssociated("AppearanceKit.strokeColor") }
        set { Associator(self).setAssociated("AppearanceKit.strokeColor", newValue) }
    }
}

