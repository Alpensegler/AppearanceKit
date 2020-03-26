//
//  Appearance.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

struct TraitValue {
    var value: AnyHashable
    var environment: AppearanceEnvironmentValue
}

@dynamicMemberLookup
public struct Appearance<Base: AppearanceTraitCollection>: CustomStringConvertible {
    @Referance var traits: [Int: TraitValue]
    @Referance var changingTrait: [Int: TraitValue]
    @Referance var traitCollection: UITraitCollection?
    let appearanceTrait = AppearanceTrait()
    let base: Base
    
    init(_ base: Base) {
        self.base = base
        self._traits = .init(assciatedIn: base, key: "AppearanceKit.traits")
        self._changingTrait = .init(assciatedIn: base, key: "AppearanceKit.changeTraits")
        self._traitCollection = .init(assciatedIn: base, key: "AppearanceKit.traitCollection", wrappedValue: (base as? UITraitEnvironment)?.traitCollection)
    }
    
    func clearChangingTrait() {
        changingTrait.removeAll()
    }
    
    func update(_ trait: TraitValue?, key: Int) {
        traits[key] = trait
        changingTrait[key] = trait
        base.configureAppearance()
        changingTrait.removeAll()
    }
    
    func updateWithTraitCollection(
        _ traitCollection: UITraitCollection
    ) {
        self.traitCollection = traitCollection
        for (key, trait) in traits {
            guard let getter = trait.environment.anyHashableGetter else { continue }
            let triatValue = getter(traitCollection)
            guard triatValue != trait.value else { continue }
            update(.init(value: triatValue, environment: trait.environment), key: key)
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
            return traits[keyPath.hashValue]?.value as? Value ?? {
                let environment = appearanceTrait[keyPath: keyPath]
                traits[keyPath.hashValue] = .init(value: environment.defaultValue, environment: environment)
                return environment.defaultValue
            }()
        }
        nonmutating set {
            let trait = traits[keyPath.hashValue] ?? {
                let environment = appearanceTrait[keyPath: keyPath]
                return .init(value: environment.defaultValue, environment: environment)
            }()
            if trait.value == AnyHashable(newValue) { return }
            update(.init(value: newValue, environment: trait.environment), key: keyPath.hashValue)
        }
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> BindableProperty<Base, Value> {
        .init(root: base, keyPath: keyPath)
    }
    
    func didChange<Value: Hashable>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.EnvironmentValue<Value>>
    ) -> Bool {
        changingTrait[keyPath.hashValue] != nil
    }
}
