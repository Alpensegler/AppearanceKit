//
//  UIWindow+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIWindow {
    static let swizzleWindowForAppearanceOne: Void = {
        swizzle(selector: #selector(UIWindow.init(frame:)), to: #selector(__init))
        swizzle(selector: #selector(setter: UIWindow.rootViewController), to: #selector(__setRootViewController(_:)))
    }()
    
    override var viewControllerForUpdate: UIViewController? { rootViewController }
    
    @objc func __init() -> UIWindow {
        let window = __init()
        window.configureAppearance()
        return window
    }
    
    @objc func __setRootViewController(_ vc: UIViewController) {
        __setRootViewController(vc)
        vc._updateAppearance(traits: traits.traits, configOnceIfNeeded: true)
    }
}
