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
        let value = AppearanceTrait()[keyPath: keyPath].value
        self.init(dynamicAppearanceBase: provider(value))
        dynamicAppearanceProvider = (keyPath.hashValue, { ($0 as? Value).map(provider) })
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
            let value = appearance.traits.changingTrait[key]?.environment.value,
            var provided = provider(value) as? DynamicAppearanceBase
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

public extension DynamicAppearanceType where Self: AnyObject {
    var dynamicColorProvider: UIColor? {
        get { Associator(self).getAssociated("dynamicColorProvider") }
        nonmutating set { Associator(self).setAssociated("dynamicColorProvider", newValue) }
    }
    
    var dynamicAppearanceProvider: (key: Int, provider: (AnyHashable) -> AnyObject?)? {
        get { Associator(self).getAssociated("dynamicAppearanceProvider") }
        nonmutating set { Associator(self).setAssociated("dynamicAppearanceProvider", newValue) }
    }
}

