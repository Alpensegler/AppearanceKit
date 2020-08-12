//
//  UIApplication+AppearanceKit.swift
//  AppearanceKit
//
//  Created by 梁钜豪 on 2020/7/30.
//

import Foundation

// via: https://github.com/onevcat/Kingfisher/blob/510d21c612aa9886ebaf4e2f573f3d28f8e8a6dc/Sources/Cache/ImageCache.swift
#if !os(macOS) && !os(watchOS)
// MARK: - For App Extensions
public extension UIApplication {
    static var ao_shared: UIApplication? = {
        let selector = NSSelectorFromString("sharedApplication")
        guard UIApplication.responds(to: selector) else { return nil }
        return UIApplication.perform(selector).takeUnretainedValue() as? UIApplication
    }()
}
#endif
