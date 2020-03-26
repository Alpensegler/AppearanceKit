//
//  Setup.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/15.
//

import UIKit

public enum AppearanceManager {
    public static func setup() {
        _ = UIColor.swizzleForAppearanceOne
        _ = UIView.swizzleForAppearanceOne
        _ = UIImageView.swizzleImageForAppearanceOne
        _ = UIViewController.swizzleForAppearanceOne
    }
}
