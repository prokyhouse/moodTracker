//
//  FormatterAssembly.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 09.10.2024.
//


import Common
import Foundation
import Design

public final class FormatterAssembly: Assembly {
    // MARK: - Private Properties

    // MARK: - Public Properties

    public var moodUIFormatter: MoodUIFormatter {
        define(
            scope: .lazySingleton,
            init: MoodUIFormatterImpl()
        )
    }
}
