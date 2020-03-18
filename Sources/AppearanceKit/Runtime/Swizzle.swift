//
//  Swizzle.swift
//  AppearanceKit
//
//  Created by Frain on 2020/3/15.
//

import ObjectiveC.runtime

public extension NSObjectProtocol where Self: NSObject {
    static func swizzle<Function, Block>(selector: Selector, functionType: Function.Type, block: (@escaping () -> Function) -> Block) {
        guard let originalMethod = class_getInstanceMethod(Self.self, selector) else {
            fatalError("\(selector) must be implemented")
        }

        let originalImp = method_getImplementation(originalMethod)
        let block = block { unsafeBitCast(originalImp, to: Function.self) }

        let swizzledIMP = imp_implementationWithBlock(unsafeBitCast(block, to: AnyObject.self))
        method_setImplementation(originalMethod, swizzledIMP)
    }
    
    static func swizzle(selector: Selector, to newSelector: Selector) {
        guard let oldMethod = class_getInstanceMethod(Self.self, selector),
            let newMethod = class_getInstanceMethod(Self.self, newSelector) else {
            fatalError("\(selector),  \(newSelector) must be implemented")
        }
        
        let oldImplementation = method_getImplementation(oldMethod)
        let newImplementation = method_getImplementation(newMethod)
        method_setImplementation(oldMethod, newImplementation)
        method_setImplementation(newMethod, oldImplementation)
    }
}
