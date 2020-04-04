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
    
    static func bindEnvironment<Value, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> DynamicAppearanceBase
    ) -> DynamicAppearanceBase
    
    func resolved<Base>(for appearance: Appearance<Base>) -> DynamicAppearanceBase?
}

public extension DynamicAppearanceType where Self: AnyObject, DynamicAppearanceBase == Self {
    init(dynamicAppearanceBase: DynamicAppearanceBase) { self = dynamicAppearanceBase }

    init<Attribute>(
        bindEnvironment keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Bool, Attribute>>,
        trueAppearance: @escaping @autoclosure () -> DynamicAppearanceBase,
        falseAppearance: @escaping @autoclosure () -> DynamicAppearanceBase
    ) {
        self.init(dynamicAppearanceBase: .bindEnvironment(keyPath) {
            let trueAppearance = Referance(wrappedValue: trueAppearance())
            let falseAppearance = Referance(wrappedValue: falseAppearance())
            return $0 ? trueAppearance.wrappedValue : falseAppearance.wrappedValue
        })
    }

    init(lightAppearance: @escaping @autoclosure () -> DynamicAppearanceBase, darkAppearance: @escaping @autoclosure () -> DynamicAppearanceBase) {
        self.init(bindEnvironment: \.isUserInterfaceDark, trueAppearance: darkAppearance(), falseAppearance: lightAppearance())
    }
}

struct DynamicProvider<DynamicAppearanceBase> {
    var key: Int
    var value: AnyHashable
    var provider: (AnyHashable) -> DynamicAppearanceBase
    var getValue: (AppearanceType, AnyHashable) -> AnyHashable?
    
    func resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> (DynamicAppearanceBase, DynamicProvider<DynamicAppearanceBase>)? {
        guard let value = getValue(appearance, value) else { return nil }
        return (provider(value), DynamicProvider(key: key, value: value, provider: provider, getValue: getValue))
    }
    
    static func fromBind<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> DynamicAppearanceBase
    ) -> (DynamicAppearanceBase, DynamicProvider<DynamicAppearanceBase>) {
        let environment = AppearanceTrait()[keyPath: keyPath]
        let value = environment.value
        return (provider(value), DynamicProvider(key: keyPath.hashValue, value: value, provider: { provider($0 as! Value) }, getValue: { $0[keyPath, notEqualTo: $1] }))
    }
}

struct StoredDynamicProvider<DynamicAppearanceBase> {
    var resolved: DynamicAppearanceBase
    var provider: DynamicProvider<DynamicAppearanceBase>
}

extension StoredDynamicProvider {
    init<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> DynamicAppearanceBase
    ) {
        let (resolved, provider) = DynamicProvider<DynamicAppearanceBase>.fromBind(keyPath, by: provider)
        self.init(resolved: resolved, provider: provider)
    }
    
    func resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> StoredDynamicProvider<DynamicAppearanceBase>? {
        guard let (resolved, provider) = provider.resolved(for: appearance) else { return nil }
        return .init(resolved: resolved, provider: provider)
    }
}

protocol ProvidableAppearanceType: DynamicAppearanceType where DynamicAppearanceBase: ProvidableAppearanceType {
    var resloved: DynamicAppearanceBase? { get }
}

protocol DynamicProvidableAppearanceType: ProvidableAppearanceType where DynamicAppearanceBase: DynamicProvidableAppearanceType {
    var dynamicProvider: DynamicProvider<DynamicAppearanceBase>? { get nonmutating set }
}

protocol StoredDynamicProvidableAppearanceType: ProvidableAppearanceType where DynamicAppearanceBase: StoredDynamicProvidableAppearanceType {
    var dynamicProvider: StoredDynamicProvider<DynamicAppearanceBase>? { get nonmutating set }
    
    static var defaultBase: DynamicAppearanceBase { get }
}

extension DynamicProvidableAppearanceType {
    static func _bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> DynamicAppearanceBase
    ) -> DynamicAppearanceBase {
        let (resolved, dynamicProvider) = DynamicProvider.fromBind(keyPath, by: provider)
        resolved.dynamicProvider = dynamicProvider
        return resolved
    }
    
    func _resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> DynamicAppearanceBase? {
        guard let (image, dynamicProvider) = dynamicProvider?.resolved(for: appearance) else { return nil }
        image.dynamicProvider = dynamicProvider
        return image
    }
}

extension DynamicProvidableAppearanceType where Self == DynamicAppearanceBase {
    var resloved: DynamicAppearanceBase? { dynamicProvider == nil ? nil : self }
}

extension StoredDynamicProvidableAppearanceType {
    static func _bindEnvironment<Value: Hashable, Attribute>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Attribute>>,
        by provider: @escaping (Value) -> DynamicAppearanceBase
    ) -> DynamicAppearanceBase {
        let base = Self.defaultBase
        base.dynamicProvider = .init(keyPath, by: provider)
        return base
    }
    
    func _resolved<Base: AppearanceEnvironment>(for appearance: Appearance<Base>) -> DynamicAppearanceBase? {
        dynamicProvider?.resolved(for: appearance)?.resolved
    }
    
    var resloved: DynamicAppearanceBase? { dynamicProvider?.resolved }
}

