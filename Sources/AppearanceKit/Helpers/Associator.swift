//
//  Associator.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/14.
//

import ObjectiveC.runtime

public protocol Associatable: class { }

public struct Associator<Object: AnyObject> {
    public enum Policy {
        case assign
        case retain
        case weak
        case copy
        
        var policy: objc_AssociationPolicy {
            switch self {
            case .assign: return .OBJC_ASSOCIATION_ASSIGN
            case .retain, .weak: return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            case .copy: return .OBJC_ASSOCIATION_COPY
            }
        }
    }
    
    let object: Object
}

public extension Associator {
    init(_ object: Object) {
        self.object = object
    }
    
    func getAssociated<T: DefaultInitializable>(_ key: AnyHashable, policy: Policy = .retain) -> T {
        getAssociated(key, policy: policy, initialValue: .init())
    }
    
    func getAssociated<T>(_ key: AnyHashable, policy: Policy = .retain, initialValue: @autoclosure () -> T) -> T {
        var value = objc_getAssociatedObject(object, key.address)
        if case .weak = policy, let getter = value as? () -> AnyObject? { value = getter() }
        return value as? T ?? {
            let initialValue = initialValue()
            setAssociated(key, initialValue, policy: policy)
            return initialValue
        }()
    }
    
    func setAssociated<T>(_ key: AnyHashable, _ newValue: T?, policy: Policy = .retain) {
        let value: Any?
        if case .weak = policy, let newValue = newValue {
            weak var anyObject = newValue as AnyObject?
            value = { anyObject }
        } else {
            value = newValue
        }
        objc_setAssociatedObject(object, key.address, value, policy.policy)
    }
}

public extension Associatable {
    func getAssociated<T: DefaultInitializable>(_ key: String, policy: Associator<Self>.Policy = .retain) -> T {
        Associator(self).getAssociated(key, policy: policy)
    }
    
    func getAssociated<T>(_ key: String, policy: Associator<Self>.Policy = .retain, initialValue: @autoclosure () -> T) -> T {
        Associator(self).getAssociated(key, policy: policy, initialValue: initialValue())
    }
    
    func setAssociated<T>(_ key: String, _ newValue: T?, policy: Associator<Self>.Policy = .retain) {
        Associator(self).setAssociated(key, newValue, policy: policy)
    }
    
    func getAssociated<T: DefaultInitializable>(_ keyPath: KeyPath<Self, T>, policy: Associator<Self>.Policy = .retain) -> T {
        Associator(self).getAssociated(keyPath, policy: policy)
    }
    
    func getAssociated<T>(_ keyPath: KeyPath<Self, T>, policy: Associator<Self>.Policy = .retain, initialValue: @autoclosure () -> T) -> T {
        Associator(self).getAssociated(keyPath, policy: policy, initialValue: initialValue())
    }
    
    func setAssociated<T>(_ keyPath: KeyPath<Self, T>, _ newValue: T?, policy: Associator<Self>.Policy = .retain) {
        Associator(self).setAssociated(keyPath, newValue, policy: policy)
    }
}

extension NSObject: Associatable { }

fileprivate extension Hashable {
    var address: UnsafeRawPointer {
        return UnsafeRawPointer(bitPattern: abs(hashValue))!
    }
}
