//
//  UIWindow+AppearanceKit.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/16.
//

import UIKit

extension UIWindow {
    override var hierachyForUpdate: [UIView] { subviews.filter { $0 !== rootViewController?.view } }
    override var viewControllerForUpdate: UIViewController? { rootViewController }
}
