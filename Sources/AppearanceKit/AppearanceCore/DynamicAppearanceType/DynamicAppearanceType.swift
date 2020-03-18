//
//  DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import Foundation

public protocol DynamicAppearanceType {
    associatedtype DynamicAppearanceBase: DynamicAppearanceType = Self
        where DynamicAppearanceBase.DynamicAppearanceBase == DynamicAppearanceBase
    init(_ dynamicAppearanceBase: DynamicAppearanceBase)
    
    func resolved(for appearance: Appearance) -> DynamicAppearanceBase?
    
    static var defaultAppearance: DynamicAppearanceBase { get }
}

public extension DynamicAppearanceType where Self: AnyObject, DynamicAppearanceBase == Self {
    init(_ dynamicAppearanceBase: DynamicAppearanceBase) { self = dynamicAppearanceBase }
    
    init(dynamicAppearanceProvider: @escaping (Appearance) -> DynamicAppearanceBase) {
        self.init(Self.defaultAppearance)
        self.dynamicAppearanceProvider = dynamicAppearanceProvider
    }
    
    init(light: DynamicAppearanceBase, dark: DynamicAppearanceBase) {
        self.init { $0.isDarkUserInterfaceStyle ? dark : light }
    }
}

public extension DynamicAppearanceType where Self: AnyObject, Self: Equatable, DynamicAppearanceBase == Self {
    func resolved(for appearance: Appearance) -> DynamicAppearanceBase? {
        let dynamicType = _resolved(for: appearance)
        dynamicType?.dynamicAppearanceProvider = dynamicAppearanceProvider
        return dynamicType
    }
}

public extension DynamicAppearanceType where Self: NSObject, DynamicAppearanceBase == Self {
    static var defaultAppearance: DynamicAppearanceBase { .init() }
}

extension DynamicAppearanceType where Self: AnyObject, DynamicAppearanceBase == Self {
    var dynamicAppearanceProvider: ((Appearance) -> DynamicAppearanceBase)? {
        get { Associator(self).getAssociated("dynamicAppearanceProvider") }
        nonmutating set { Associator(self).setAssociated("dynamicAppearanceProvider", newValue) }
    }
    
    func _addingProvider(_ provider: ((Appearance) -> Self)?) -> Self {
        dynamicAppearanceProvider = provider
        return self
    }
}

extension DynamicAppearanceType where Self: AnyObject, Self: Equatable, DynamicAppearanceBase == Self {
    func _resolved(for appearance: Appearance) -> DynamicAppearanceBase? {
        guard let dynamicType = dynamicAppearanceProvider?(appearance) else { return nil }
        return dynamicType == self ? nil : dynamicType
    }
}

