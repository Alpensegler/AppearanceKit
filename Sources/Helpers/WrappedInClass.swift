//
//  WrappedInClass.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/24.
//

@propertyWrapper
struct Referance<Value> {
    let getter: () -> Value
    let setter: (Value) -> Void
    
    public var wrappedValue: Value {
        get { getter() }
        nonmutating set { setter(newValue) }
    }
    
    public init(wrappedValue: @escaping @autoclosure () -> Value) {
        var value: Value?
        func getValue() -> Value {
            value ?? {
                let actualValue = wrappedValue()
                value = actualValue
                return actualValue
            }()
        }
        setter = { value = $0 }
        getter = { getValue() }
    }
    
    public init(assciatedIn object: AnyObject, key: String, wrappedValue: @escaping @autoclosure () -> Value) {
        getter = { Associator(object).getAssociated(key, initialValue: wrappedValue()) }
        setter = { Associator(object).setAssociated(key, $0) }
    }
    
    public init<Object: AnyObject>(in object: Object, of keyPath: ReferenceWritableKeyPath<Object, Value>) {
        getter = { object[keyPath: keyPath] }
        setter = { object[keyPath: keyPath] = $0 }
    }
}

extension Referance where Value: DefaultInitializable {
    init(assciatedIn object: AnyObject, key: String) {
        self.init(assciatedIn: object, key: key, wrappedValue: .init())
    }
}
