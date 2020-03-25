//
//  Appearance.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

typealias TraitValue = (Value: AnyHashable, environment: AppearanceEnvironmentValue)

@dynamicMemberLookup
public struct Appearance<Base: AppearanceTraitCollection>: CustomStringConvertible {
    @WrappedInAssociated var traits: [AnyHashable: TraitValue]
    @WrappedInAssociated var changingTrait: [AnyHashable: TraitValue]
    @WrappedInAssociated var traitCollection: UITraitCollection?
    let appearanceTrait = AppearanceTrait()
    let base: Base
    
    init(_ base: Base) {
        self.base = base
        self._traits = .init(base: base, key: "AppearanceKit.traits")
        self._changingTrait = .init(base: base, key: "AppearanceKit.changeTraits")
        self._traitCollection = .init(base: base, key: "AppearanceKit.traitCollection", wrappedValue: (base as? UITraitEnvironment)?.traitCollection)
    }
    
    func clearChangingTrait() {
        changingTrait.removeAll()
    }
    
    func update(_ trait: TraitValue?, key: AnyHashable) {
        traits[key] = trait
        changingTrait[key] = trait
        base.configureAppearance()
        changingTrait.removeAll()
    }
    
    func updateWithTraitCollection(
        _ traitCollection: UITraitCollection
    ) {
        self.traitCollection = traitCollection
        for (key, (value, environment)) in traits {
            guard let getter = environment.anyHashableGetter else { continue }
            let triatValue = getter(traitCollection)
            guard triatValue != value else { continue }
            update((triatValue, environment), key: key)
        }
    }
    
    public var description: String {
        """
        \(traits)
        \(changingTrait)
        """
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
