//
//  AppearanceCollection.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

public protocol AppearanceCollection: AnyObject {
    var currentAppearance: Appearance { get set }
    func configureAppearance()
}

public extension AppearanceCollection {
    func updateAppearance(_ closure: (inout Appearance) -> Void) {
        var current = currentAppearance
        closure(&current)
        currentAppearance = current
    }
}

extension AppearanceCollection where Self: UITraitEnvironment, Self: NSObject {
    var _currentAppearance: Appearance {
        get {
            appearance ?? {
                let appearance = Appearance(traitCollection: traitCollection)
                self.appearance = appearance
                return appearance
            }()
        }
        set {
            var appearance = newValue
            appearance.configCurrentOnly = false
            update(to: appearance)
        }
    }
}

extension AppearanceCollection where Self: NSObject {
    var appearance: Appearance? {
        get { getAssociated("appearance") }
        set { setAssociated("appearance", newValue) }
    }
    
    func update(to appearance: Appearance, withTraitCollection: Bool = false) {
        if var currentAppearance = self.appearance {
            currentAppearance.configForUpdate(to: appearance)
            self.appearance = currentAppearance
        } else {
            self.appearance = appearance
            self.appearance?.attributesStorage.cachedAttributes.removeAll(keepingCapacity: true)
        }
        configureAppearance()
    }
    
    func update<T>(to appearance: Appearance, _ getter: T?, _ setter: (T?) -> Void)
    where T: DynamicAppearanceType, T.DynamicAppearanceBase == T {
        if let resolved = getter?.resolved(for: appearance) {
            setter(resolved)
        }
    }
    
    func update<T>(to appearance: Appearance, _ dynamicAppearanceType: inout T?)
    where T: DynamicAppearanceType, T.DynamicAppearanceBase == T {
        update(to: appearance, dynamicAppearanceType) { dynamicAppearanceType = $0 }
    }
}
