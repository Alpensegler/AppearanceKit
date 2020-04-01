//
//  Appearance.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import UIKit

struct Traits<Attribute>: DefaultInitializable {
    typealias Value = (used: Bool, environment: AnyEnvironment<Attribute>)
    
    var traits = [Int: Value]()
    var changingTrait = [Int: Value]()
}

@dynamicMemberLookup
public struct Appearance<Base: AppearanceEnvironment> {
    @Referance var traits: Traits<Void>
    @Referance var uiTraits: Traits<(UITraitCollection) -> AnyHashable>
    @Referance var traitCollection: UITraitCollection!
    @Referance var didConfigureOnce: Bool
    var isBatch = false
    let base: Base
}

extension Appearance: CustomStringConvertible {
    public var description: String { "\(traits)" }
}

public extension Appearance {
    subscript<Value: Hashable>(
        dynamicMember keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Void>>
    ) -> Value {
        get {
            let key = keyPath.hashValue
            return traits.traits[key]?.environment.value as? Value ?? {
                let environment = AppearanceTrait()[keyPath: keyPath]
                traits.traits[key] = (true, .init(defaultValue: environment.value))
                return environment.value
            }()
        }
        nonmutating set {
            let key = keyPath.hashValue
            let trait = traits.traits[key] ?? {
                let environment = AppearanceTrait()[keyPath: keyPath]
                let result = (true, AnyEnvironment(defaultValue: environment.value))
                traits.traits[keyPath.hashValue] = result
                return result
            }()
            if trait.environment.value == AnyHashable(newValue) { return }
            let value: Traits<Void>.Value = (trait.used, .init(defaultValue: newValue))
            traits.traits[key] = value
            traits.changingTrait[key] = value
            if !isBatch { configureAppearance() }
        }
    }
    
    subscript<Value: Hashable>(
        dynamicMember keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, (UITraitCollection) -> Value>>
    ) -> Value {
        uiTraits.traits[keyPath.hashValue]?.environment.value as? Value ?? {
            let environment = AppearanceTrait()[keyPath: keyPath]
            let defaultValue = traitCollection.map(environment.attribute) ?? environment.value
            let attribute = environment.attribute
            uiTraits.traits[keyPath.hashValue] = (true, .init(value: defaultValue, attribute: { attribute($0) }))
            return defaultValue
        }()
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> BindableProperty<Base, Value> {
        .init(root: base, keyPath: keyPath)
    }
    
    func didChange<Value: Hashable>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, Void>>
    ) -> Bool {
        traits.changingTrait[keyPath.hashValue] != nil
    }
    
    func didChange<Value: Hashable>(
        _ keyPath: KeyPath<AppearanceTrait, AppearanceTrait.Environment<Value, (UITraitCollection) -> Value>>
    ) -> Bool {
        uiTraits.changingTrait[keyPath.hashValue] != nil
    }
    
    func performBatchUpdate(_ update: (Self) -> Void) {
        var mutableSelf = self
        mutableSelf.isBatch = true
        update(mutableSelf)
        guard !mutableSelf.traits.changingTrait.isEmpty else { return }
        mutableSelf.configureAppearance()
    }
}

extension Appearance {
    init(_ base: Base) {
        self.base = base
        self._traits = .init(assciatedIn: base, key: "AppearanceKit.traits")
        self._uiTraits = .init(assciatedIn: base, key: "AppearanceKit.uiTraits")
        self._traitCollection = .init(assciatedIn: base, key: "AppearanceKit.traitCollection")
        self._didConfigureOnce = .init(assciatedIn: base, key: "AppearanceKit.didConfigureOnce")
    }
    
    func setConfigureOnce() {
        didConfigureOnce = true
    }
    
    func configureAppearance(force: Bool = false) {
        force ? base.configureAppearance() : base.configureAppearanceChange()
        traits.changingTrait.removeAll()
        uiTraits.changingTrait.removeAll()
    }
    
    func update(traits: [Int: Traits<Void>.Value]? = nil, traitCollection: UITraitCollection? = nil, configOnceIfNeeded: Bool) {
        var hasChange = false
        if let traits = traits {
            for (key, trait) in traits {
                if let selfTrait = self.traits.traits[key], selfTrait.environment.value != trait.environment.value, selfTrait.used {
                    self.traits.traits[key] = (true, trait.environment)
                    self.traits.changingTrait[key] = trait
                    hasChange = true
                } else {
                    self.traits.traits[key] = trait
                }
            }
        }
        
        if let traitCollection = traitCollection {
            hasChange = setTraitCollection(traitCollection) || hasChange
        }
        
        if configOnceIfNeeded, !didConfigureOnce {
            configureAppearance(force: true)
        } else if hasChange {
            configureAppearance()
        }
    }
    
    @discardableResult
    func setTraitCollection(_ traitCollection: @autoclosure () -> UITraitCollection?) -> Bool {
        let oldTraitCollection = self.traitCollection
        guard let traitCollection = traitCollection(), oldTraitCollection !== traitCollection else { return false }
        self.traitCollection = traitCollection
        var hasChange = false
        for (key, trait) in uiTraits.traits {
            let triatValue = trait.environment.attribute(traitCollection)
            guard triatValue != trait.environment.value else { continue }
            uiTraits.traits[key] = trait
            uiTraits.changingTrait[key] = trait
            hasChange = true
        }
        return hasChange
    }
}
