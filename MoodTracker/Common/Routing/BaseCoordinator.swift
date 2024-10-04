//
//  BaseCoordinator.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import UIKit

open class BaseCoordinator<RootType: Presenter>: NSObject, Coordinator, CoordinatorDelegate {
    // MARK: - Public Properties

    public let root: RootType

    public weak var delegate: CoordinatorDelegate? {
        get {
            delegateProxy.originalDelegate
        }
        set {
            delegateProxy.originalDelegate = newValue
        }
    }

    @Atomic public private(set) var children: [any Coordinator] = []

    // MARK: - Private Properties

    internal var delegateProxy = CoordinatorDelegateProxy()
    private let logger = Logger(category: .routing)

    // MARK: - Lifecycle

    public init(root: RootType) {
        self.root = root
        super.init()
        #if !RELEASE
        logger.log(
            .debug("🚀✅ Coordinator inited"),
            .public("object", value: "\(type(of: self)) [\(Unmanaged.passUnretained(self).toOpaque())]")
        )
        #endif
    }

    deinit {
        children.removeAll()
        #if !RELEASE
        logger.log(
            .debug("🚀🗑 Coordinator deinited"),
            .public("object", value: "\(type(of: self)) [\(Unmanaged.passUnretained(self).toOpaque())]")
        )
        #endif
    }

    // MARK: - Public Methods

    open func add(child coordinator: any Coordinator) {
        coordinator.delegate = self
        children.append(coordinator)
    }

    open func remove(child coordinator: any Coordinator) {
        children.removeAll(where: { coordinator === $0 })
    }

    open func removeAll() {
        children = []
    }

    open func start() {
        assertionFailure("this method must be overridden")
    }

    open func close(animated: Bool = true) {
        switch root {
        case let root as UIViewController:
            root.dismiss(animated: animated, completion: { [weak self] in
                guard let self else { return }
                self.didClosed()
            })

        default:
            break
        }
    }

    open func didClosed() {
        self.delegateProxy.coordinatorDidClose(self)
        #if !RELEASE
        logger.log(
            .notice("🚀🏁 Coordinator did close"),
            .public("object", value: "\(type(of: self)) [\(Unmanaged.passUnretained(self).toOpaque())]")
        )
        #endif
    }

    // MARK: - CoordinatorDelegate

    open func coordinatorDidClose(_ coordinator: some Coordinator) {
        remove(child: coordinator)
    }
}
