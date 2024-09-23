//
//  ResourceConvertible.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 16.02.2023.
//

import Foundation

public protocol ResourceConvertible {
    // MARK: - Constants

    associatedtype ResourceType

    // MARK: - Properties

    var rawValue: String { get }

    // MARK: - Functions

    func get() -> ResourceType
}
