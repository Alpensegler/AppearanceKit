//
//  UIBindable.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/25.
//

public protocol UIBindable {
    associatedtype Value
    
    var wrappedValue: Value { get }
}

@propertyWrapper
public class UIState<Value>: UIBindable {
    weak var component: AppearanceTraitCollection?
    
    public var wrappedValue: Value
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    public var projectedValue: UIState<Value> {
        return self
    }
}
