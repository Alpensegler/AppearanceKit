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

public extension WrappedInClass where Value: DefaultInitializable {
    convenience init() {
        self.init(wrappedValue: .init())
    }
}
