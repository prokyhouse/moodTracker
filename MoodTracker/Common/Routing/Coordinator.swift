//
//  Coordinator.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//


import UIKit

public protocol CoordinatorDelegate: AnyObject {
    func coordinatorDidClose(_ coordinator: some Coordinator)
}

public extension CoordinatorDelegate {
    func coordinatorDidClose(_ coordinator: some Coordinator) { }
}

public protocol Coordinator: AnyObject {
    associatedtype RootType: Presenter

    var delegate: CoordinatorDelegate? { get set }
    var root: RootType { get }
    var children: [any Coordinator] { get }

    func start()
    func add(child coordinator: any Coordinator)
    func remove(child coordinator: any Coordinator)
    func removeAll()
}
