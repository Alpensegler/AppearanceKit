//
//  AppearanceManager.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/15.
//

import UIKit

public enum AppearanceManager {
    public static func setup() {
        _ = UIView.swizzleForAppearanceOne
        _ = UILabel.swizzleLabelForAppearanceOne
        _ = UITextView.swizzleTextViewForAppearanceOne
        _ = UITextField.swizzleTextFeildForAppearanceOne
        _ = UIButton.swizzleButtonForAppearanceOne
        _ = UIWindow.swizzleWindowForAppearanceOne
        _ = UIImageView.swizzleImageForAppearanceOne
        _ = CALayer.swizzleForAppearanceOne
        _ = CAShapeLayer.swizzleShapeColorForAppearanceOne
        _ = UIViewController.swizzleForAppearanceOne
    }
}
