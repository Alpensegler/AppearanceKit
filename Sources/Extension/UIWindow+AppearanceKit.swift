//
//  UIWindow+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIWindow {
    static let swizzleWindowForAppearanceOne: Void = {
        if #available(iOS 13.0, *) {
            swizzle(selector: #selector(UIWindow.init(windowScene:)), to: #selector(__init(windowScene:)))
        }
        swizzle(selector: #selector(UIWindow.init(frame:)), to: #selector(__init(frame:)))
        swizzle(selector: #selector(setter: UIWindow.rootViewController), to: #selector(__setRootViewController(_:)))
    }()
    
    override var viewControllerForUpdate: UIViewController? { rootViewController }
    
    @objc func __init(frame: CGRect) -> UIWindow {
        let window = __init(frame: frame)
        window.configureAppearance()
        return window
    }
    
    @available(iOS 13.0, *)
    @objc func __init(windowScene: UIWindowScene) -> UIWindow {
        let window = __init(windowScene: windowScene)
        window.configureAppearance()
        return window
    }
    
    @objc func __setRootViewController(_ vc: UIViewController?) {
        __setRootViewController(vc)
        vc?._updateAppearance(traits: traits.traits, configOnceIfNeeded: true)
    }
}
