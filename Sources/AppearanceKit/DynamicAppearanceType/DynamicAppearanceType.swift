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
    
    init<Value>(
        bindEnvironment keyPath: KeyPath<AppearanceTrait, AppearanceTrait.EnvironmentValue<Value>>,
        by provider: @escaping (Value) -> DynamicAppearanceBase
    )
    
    func customResolved<Base>(for appearance: Appearance<Base>) -> DynamicAppearanceBase?
    func resolved<Base>(for appearance: Appearance<Base>) -> DynamicAppearanceBase?
}

public extension DynamicAppearanceType where Self: AnyObject, DynamicAppearanceBase == Self {
    init(dynamicAppearanceBase: DynamicAppearanceBase) { self = dynamicAppearanceBase }
    
    init<Value>(
        bindEnvironment keyPath: KeyPath<AppearanceTrait, AppearanceTrait.EnvironmentValue<Value>>,
        by provider: @escaping (Value) -> DynamicAppearanceBase
    ) {
        let value = AppearanceTrait()[keyPath: keyPath].defaultValue
        self.init(dynamicAppearanceBase: provider(value))
    }
    
    init(
        bindEnvironment keyPath: KeyPath<AppearanceTrait, AppearanceTrait.EnvironmentValue<Bool>>,
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
            let value = appearance.changingTrait[key]?.0,
            var provided = provider(value)
        else {
            let result = customResolved(for: appearance)
            result?.dynamicAppearanceProvider = dynamicAppearanceProvider
            return result
        }
        provided = provided.customResolved(for: appearance) ?? provided
        provided.dynamicAppearanceProvider = dynamicAppearanceProvider
        return provided
    }
}

extension DynamicAppearanceType where Self: AnyObject, DynamicAppearanceBase == Self {
    var dynamicColorProvider: UIColor? {
        get { Associator(self).getAssociated("dynamicColorProvider") }
        nonmutating set { Associator(self).setAssociated("dynamicColorProvider", newValue) }
    }
    
    var dynamicAppearanceProvider: (key: AnyHashable, provider: (AnyHashable) -> DynamicAppearanceBase?)? {
        get { Associator(self).getAssociated("dynamicAppearanceProvider") }
        nonmutating set { Associator(self).setAssociated("dynamicAppearanceProvider", newValue) }
    }
}

