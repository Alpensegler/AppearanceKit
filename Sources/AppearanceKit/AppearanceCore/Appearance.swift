//
//  Appearance.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

typealias TraitValue = (Value: AnyHashable, environment: AppearanceEnvironmentValue)

protocol StoredAppearance {
    var traits: [AnyHashable: TraitValue] { get nonmutating set }
    var changingTrait: [AnyHashable: TraitValue]  { get nonmutating set }
    var traitCollection: UITraitCollection? { get }
}

@dynamicMemberLookup
public struct Appearance<Base: AppearanceTraitCollection>: StoredAppearance {
    @WrappedInClass var traits = [AnyHashable: TraitValue]()
    @WrappedInClass var changingTrait = [AnyHashable: TraitValue]()
    let appearanceTrait = AppearanceTrait()
    var traitCollection: UITraitCollection?
    let base: Base
    
    init(appearanceType: StoredAppearance?, _ base: Base) {
        self.base = base
        self.traits = appearanceType?.traits ?? [:]
        self.changingTrait = appearanceType?.changingTrait ?? [:]
        self.traitCollection = appearanceType?.traitCollection ?? (base as? UITraitEnvironment)?.traitCollection
    }
    
    mutating func update(_ trait: TraitValue?, key: AnyHashable) {
        traits[key] = trait
        changingTrait[key] = trait
    }
    
    mutating func updateWithTraitCollection(
        _ traitCollection: UITraitCollection
    ) {
        self.traitCollection = traitCollection
        for (key, (value, environment)) in traits {
            guard let getter = environment.anyHashableGetter else { continue }
            let triatValue = getter(traitCollection)
            guard triatValue == value else { continue }
            update((triatValue, environment), key: key)
        }
    }
}

public extension Appearance {
    subscript<Value: Hashable>(
        dynamicMember keyPath: KeyPath<AppearanceTrait, AppearanceTrait.EnvironmentValue<Value>>
    ) -> Value {
        get {
            return traits[keyPath]?.0 as? Value ?? {
                let environment = appearanceTrait[keyPath: keyPath]
                traits[keyPath] = (environment.defaultValue, environment)
                return environment.defaultValue
            }()
        }
        set {
            let (value, environment) = traits[keyPath] ?? {
                let environment = appearanceTrait[keyPath: keyPath]
                return (environment.defaultValue, environment)
            }()
            if value == AnyHashable(newValue) { return }
            update((newValue, environment), key: keyPath)
        }
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> BindableProperty<Base, Value> {
        .init(root: base, keyPath: keyPath)
    }
    
    func didChange<Value: Hashable>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.EnvironmentValue<Value>>
    ) -> Bool {
        changingTrait[keyPath] != nil
    }
}
