//
//  Appearance.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

@dynamicMemberLookup
public struct Appearance<Base: AppearanceTraitCollection> {
    typealias TraitValue = (Value: AnyHashable, environment: AppearanceEnvironmentValue)
    @WrappedInClass var traits = [AnyHashable: TraitValue]()
    @WrappedInClass var changingTrait = [AnyHashable: TraitValue]()
    let appearanceTrait = AppearanceTrait()
    var traitCollection: UITraitCollection?
    var throughHierarchy = false
    let base: Base
    
    init(_ base: Base) {
        self.base = base
        self.traitCollection = (base as? UITraitEnvironment)?.traitCollection
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
            throughHierarchy = throughHierarchy || environment.throughHierarchy
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
            let (value, environment) = traits[keyPath] as? (Value, AppearanceEnvironmentValue) ?? {
                let environment = appearanceTrait[keyPath: keyPath]
                return (environment.defaultValue, environment)
            }()
            if value == newValue { return }
            update((newValue, environment), key: keyPath)
        }
    }
    
    func didChange<Value: Hashable>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.EnvironmentValue<Value>>
    ) -> Bool {
        changingTrait[keyPath] != nil
    }
}
