//
//  WrappedInClass.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/24.
//

@propertyWrapper
public class WrappedInClass<Value> {
    public var wrappedValue: Value
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
public struct WrappedInAssociated<Value> {
    let base: AnyObject
    let key: String
    var initialValue: () -> Value
    
    public var wrappedValue: Value {
        get { Associator(base).getAssociated(key, initialValue: initialValue()) }
        nonmutating set { Associator(base).setAssociated(key, newValue) }
    }
    
    public init(base: AnyObject, key: String, wrappedValue: @escaping @autoclosure () -> Value) {
        self.base = base
        self.key = key
        self.initialValue = wrappedValue
    }
}


public extension WrappedInClass where Value: DefaultInitializable {
    convenience init() {
        self.init(wrappedValue: .init())
    }
}

public extension WrappedInAssociated where Value: DefaultInitializable {
    init(base: AnyObject, key: String) {
        self.base = base
        self.key = key
        self.initialValue = { .init() }
    }
}
