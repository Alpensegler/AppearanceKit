//
//  BindableProperty.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/25.
//

@dynamicMemberLookup
public final class BindableProperty<Root: AppearanceEnvironment, Value> {
    public var root: Root
    let keyPath: WritableKeyPath<Root, Value>
    
    init(root: Root, keyPath: WritableKeyPath<Root, Value>) {
        self.root = root
        self.keyPath = keyPath
    }
    
    @discardableResult
    public func callAsFunction(_ value: Value) -> Self {
        root[keyPath: keyPath] = value
        return self
    }
    
    @discardableResult
    public func callAsFunction<Bindable: UIBindable>(bind bindable: Bindable) -> Self where Bindable.Value == Value {
        root[keyPath: keyPath] = bindable.wrappedValue
        return self
    }
    
    @discardableResult
    public func callAsFunction<Bindable: UIBindable>(bind bindable: Bindable, transition: (Bindable.Value) -> (Value)) -> Self {
        root[keyPath: keyPath] = transition(bindable.wrappedValue)
        return self
    }
    
    public subscript<Value>(
        dynamicMember keyPath: WritableKeyPath<Root, Value>
    ) -> BindableProperty<Root, Value> {
        .init(root: root, keyPath: keyPath)
    }
}
