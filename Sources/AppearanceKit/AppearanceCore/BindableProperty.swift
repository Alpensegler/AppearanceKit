//
//  BindableProperty.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/25.
//

public final class BindableProperty<Root: AppearanceTraitCollection, Value> {
    var root: Root
    let keyPath: WritableKeyPath<Root, Value>
    
    init(root: Root, keyPath: WritableKeyPath<Root, Value>) {
        self.root = root
        self.keyPath = keyPath
    }
    
    @discardableResult
    public func callAsFunction(_ value: Value) -> Root {
        root[keyPath: keyPath] = value
        return root
    }
    
    @discardableResult
    public func callAsFunction<Bindable: UIBindable>(bind bindable: Bindable) -> Root where Bindable.Value == Value {
        root[keyPath: keyPath] = bindable.wrappedValue
        return root
    }
    
    @discardableResult
    public func callAsFunction<Bindable: UIBindable>(bind bindable: Bindable, transition: (Bindable.Value) -> (Value)) -> Root {
        root[keyPath: keyPath] = transition(bindable.wrappedValue)
        return root
    }
}
