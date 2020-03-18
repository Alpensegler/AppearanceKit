//
//  Appearance.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

@dynamicMemberLookup
public struct Appearance {
    public struct Attribute {
        public enum Attribute<T> {
            case traitCollection(PartialKeyPath<UITraitCollection>, (Any) -> T)
            case initialValue(@autoclosure () -> T)
            
            public static func traitCollection(_ keyPath: KeyPath<UITraitCollection, T>) -> Self {
                .traitCollection(keyPath) { $0 as! T }
            }
        }
    }
    
    final class Storage {
        var attributes = [AnyHashable: Any]()
        var cachedAttributes = [AnyHashable: Any]()
        var previousAttributes = [AnyHashable: Any]()
        
        func configForUpdate() {
            previousAttributes = cachedAttributes
            cachedAttributes.removeAll(keepingCapacity: true)
        }
    }
    
    let attributesStorage = Storage()
    let attribute = Attribute()
    var traitCollection: UITraitCollection
    var configCurrentOnly = false
    
    static var current: Appearance!
    
    func addToCache<T>(key: AnyHashable, value: T) -> T {
        attributesStorage.cachedAttributes[key] = value
        return value
    }
    
    mutating func configForUpdate(to appearance: Appearance, withTraitCollection: Bool = false) {
        attributesStorage.attributes.merge(appearance.attributesStorage.attributes) { (_, other) in other }
        configCurrentOnly = appearance.configCurrentOnly
        if withTraitCollection { traitCollection = appearance.traitCollection }
    }
}

public extension Appearance.Attribute {
    var isDarkUserInterfaceStyle: Attribute<Bool> {
        if #available(iOS 13.0, *) {
            return .traitCollection(\UITraitCollection.userInterfaceStyle) {
                $0 as? UIUserInterfaceStyle == .dark
            }
        } else {
            return .initialValue(false)
        }
    }
}

public extension Appearance {
    subscript<T>(dynamicMember keyPath: KeyPath<Attribute, Attribute.Attribute<T>>) -> T {
        get {
            switch attribute[keyPath: keyPath] {
            case let .traitCollection(keyPath, cast):
                return cast(addToCache(key: keyPath, value: traitCollection[keyPath: keyPath]))
            case let .initialValue(value):
                return addToCache(key: keyPath, value: attributesStorage.attributes[keyPath] as? T ?? {
                    let initialValue = value()
                    attributesStorage.attributes[keyPath] = initialValue
                    return initialValue
                }())
            }
        }
        set {
            guard case .initialValue = attribute[keyPath: keyPath] else { return }
            attributesStorage.attributes[keyPath] = newValue
        }
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<UITraitCollection, T>) -> T {
        addToCache(key: keyPath, value: traitCollection[keyPath: keyPath])
    }
    
    func previousAttribute<T>(_ keyPath: KeyPath<Attribute, Attribute.Attribute<T>>) -> T? {
        switch attribute[keyPath: keyPath] {
        case let .traitCollection(keyPath, cast):
            return attributesStorage.previousAttributes[keyPath].map(cast)
        case .initialValue:
            return attributesStorage.previousAttributes[keyPath] as? T
        }
    }
    
    func previousAttribute<T>(_ keyPath: KeyPath<UITraitCollection, T>) -> T? {
        attributesStorage.previousAttributes[keyPath] as? T
    }
}
