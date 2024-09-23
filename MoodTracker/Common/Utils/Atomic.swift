//
//  Atomic.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//


import Foundation

@propertyWrapper
public struct Atomic<T> {
    // MARK: Public Properties

    public var wrappedValue: T {
        get {
            return lock.withCriticalScope { value }
        }
        set {
            lock.withCriticalScope { value = newValue }
        }
    }

    // MARK: Private Properties

    private var value: T
    private let lock = NSLock()

    // MARK: Lifecycle

    public init(wrappedValue value: T) {
        self.value = value
    }
}

public extension NSLock {
    func withCriticalScope<T>(_ block: () -> T) -> T {
        lock()
        let value = block()
        unlock()
        return value
    }
}
