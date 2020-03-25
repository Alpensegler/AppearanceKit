//
//  Setup.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/15.
//

import UIKit

public enum AppearanceManager {
    public static func setup() {
        _ = UIView.swizzleForAppearanceOne
        _ = UIColor.swizzleForAppearanceOne
        _ = UIViewController.swizzleForAppearanceOne
    }
}
