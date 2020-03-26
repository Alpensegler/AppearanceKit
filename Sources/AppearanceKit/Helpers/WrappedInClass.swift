//
//  WrappedInClass.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/24.
//

@propertyWrapper
public struct Referance<Value> {
    let getter: () -> Value
    let setter: (Value) -> Void
    
    public var wrappedValue: Value {
        get { getter() }
        nonmutating set { setter(newValue) }
    }
    
    public init(wrappedValue: Value) {
        var wrappedValue = wrappedValue
        getter = { wrappedValue }
        setter = { wrappedValue = $0 }
    }
    
    public init(assciatedIn object: AnyObject, key: String, wrappedValue: Value) {
        getter = { Associator(object).getAssociated(key, initialValue: wrappedValue) }
        setter = { Associator(object).setAssociated(key, $0) }
    }
    
    public init<Object: AnyObject>(in object: Object, of keyPath: ReferenceWritableKeyPath<Object, Value>) {
        getter = { object[keyPath: keyPath] }
        setter = { object[keyPath: keyPath] = $0 }
    }
}

public extension Referance where Value: DefaultInitializable {
    init(assciatedIn object: AnyObject, key: String) {
        self.init(assciatedIn: object, key: key, wrappedValue: .init())
    }
}
