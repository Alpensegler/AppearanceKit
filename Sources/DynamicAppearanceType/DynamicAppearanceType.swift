//
//  DynamicAppearanceType.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

public protocol DynamicAppearanceType {
    associatedtype DynamicAppearanceBase: DynamicAppearanceType = Self
        where DynamicAppearanceBase.DynamicAppearanceBase == DynamicAppearanceBase
    init(dynamicAppearanceBase: DynamicAppearanceBase)
    
    init<Value, Attribute>(
        bindEnvironment keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> DynamicAppearanceBase
    )
    
    func customResolved<Base>(for appearance: Appearance<Base>) -> DynamicAppearanceBase?
    func resolved<Base>(for appearance: Appearance<Base>) -> DynamicAppearanceBase?
}

public extension DynamicAppearanceType where Self: AnyObject, DynamicAppearanceBase == Self {
    init(dynamicAppearanceBase: DynamicAppearanceBase) { self = dynamicAppearanceBase }
    
    init<Value, Attribute>(
        bindEnvironment keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> DynamicAppearanceBase
    ) {
        let environment = AppearanceTrait()[keyPath: keyPath]
        self.init(dynamicAppearanceBase: provider(environment.value))
        dynamicAppearanceProvider = (keyPath.hashValue, { provider($0[keyPath]) })
    }

    init<Attribute>(
        bindEnvironment keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Bool, Attribute>>,
        trueAppearance: DynamicAppearanceBase,
        falseAppearance: DynamicAppearanceBase
    ) {
        self.init(bindEnvironment: keyPath) { $0 ? trueAppearance : falseAppearance }
    }

    init(lightAppearance: DynamicAppearanceBase, darkAppearance: DynamicAppearanceBase) {
        self.init(bindEnvironment: \.isUserInterfaceDark, trueAppearance: lightAppearance, falseAppearance: darkAppearance)
    }
    
    func customResolved<Base>(for appearance: Appearance<Base>) -> DynamicAppearanceBase? { nil }
    
    func resolved<Base>(for appearance: Appearance<Base>) -> DynamicAppearanceBase? {
        guard let (key, provider) = dynamicAppearanceProvider,
            appearance.traits.changingTrait[key] != nil || appearance.traits.traits[key] == nil
        else {
            let result = customResolved(for: appearance)
            result?.dynamicAppearanceProvider = dynamicAppearanceProvider
            return result
        }
        let shouldReturnNil = appearance.traits.traits[key] == nil
        let provided = provider(appearance)
        let result = provided.customResolved(for: appearance) ?? (shouldReturnNil ? nil : provided)
        result?.dynamicAppearanceProvider = dynamicAppearanceProvider
        return result
    }
}

extension DynamicAppearanceType where Self: AnyObject {
    var dynamicAppearanceProvider: (key: Int, provider: (AppearanceType) -> DynamicAppearanceBase)? {
        get { Associator(self).getAssociated("dynamicAppearanceProvider") }
        nonmutating set { Associator(self).setAssociated("dynamicAppearanceProvider", newValue) }
    }
}

