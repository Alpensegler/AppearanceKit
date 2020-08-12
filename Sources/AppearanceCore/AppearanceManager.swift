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
        _ = UIWindow.swizzleWindowForAppearanceOne
        _ = UIImageView.swizzleImageForAppearanceOne
        _ = CALayer.swizzleForAppearanceOne
        _ = CAShapeLayer.swizzleShapeColorForAppearanceOne
        _ = UIViewController.swizzleForAppearanceOne
        _ = NSMutableAttributedString.swizzleForAppearanceOne
    }
    
    public static func updateEnvironment<Value>(
        for application: UIApplication? = .ao_shared,
        _ keypath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Void>>,
        with value: Value,
        animated: Bool
    ) {
        assert(Thread.isMainThread)

        if animated {
            var snapshotViews: [UIView] = []
            application?.windows.forEach { view in
                guard let snapshotView = view.snapshotView(afterScreenUpdates: false) else {
                    return
                }
                view.addSubview(snapshotView)
                snapshotViews.append(snapshotView)
            }
            
            application?.windows.forEach { $0.ap[dynamicMember: keypath] = value }
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: [], animations: {
                snapshotViews.forEach { $0.alpha = 0 }
            }) { _ in
                snapshotViews.forEach { $0.removeFromSuperview() }
            }
        } else {
            application?.windows.forEach { $0.ap[dynamicMember: keypath] = value }
        }
    }
}
