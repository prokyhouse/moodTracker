//
//  Category.swift
//  MoodTracker
//
//  Created by Kirill Prokofyev on 22.09.2024.
//

import Foundation
import os.log

// MARK: - Category

public extension Logger {
    enum Category: String {
        /// Общие логи
        case common
        /// Логи сетевых запросов, ошибок и т. д.
        case network
        /// Логи базы данных
        case database
        /// Логи навигации по приложению
        case routing
        /// Логи пушей, в т.ч. из Firebase
        case apns
        /// Логи аналитики
        case analytics
    }
}

// MARK: - Body

public extension Logger.Message {
    enum Body {
        /// Сообщения уровня отладки предназначены для использования в среде разработки во время активной отладки.
        case debug(_ body: String)
        /// Уровень журнала по умолчанию, который на самом деле ничего не говорит о ведении журнала.
        /// Лучше быть конкретным, используя другие уровни ведения журнала.
        case notice(_ body: String)
        /// Вызовите эту функцию, чтобы получить информацию, которая может быть полезна,
        /// но не является существенной, для устранения неполадок.
        case info(_ body: String)
        /// Сообщения на уровне ошибок предназначены для сообщения о критических ошибках и сбоях.
        case error(_ body: String)
    }
}

public extension Logger.Message.Body {
    var value: String {
        switch self {
        case let .debug(value), let .notice(value), let .info(value), let .error(value):
            return value
        }
    }
}

private extension Logger.Message.Body {
    func asSystemMessageType() -> SystemMessageType {
        switch self {
        case .debug:
            return .debug

        case .notice:
            return .notice

        case .info:
            return .info

        case .error:
            return .error
        }
    }
}

// MARK: - Paramater

public extension Logger.Message {
    enum Parameter {
        case `public`(_ key: String, value: Any?)
        case `private`(_ key: String, value: Any?)
    }
}

public extension Logger.Message.Parameter {
    var isSensitive: Bool {
        guard case .private = self else { return false }
        return true
    }

    var key: String {
        switch self {
        case let .public(key, _), let .private(key, _):
            return key
        }
    }

    var value: String {
        switch self {
        case let .public(_, value), let .private(_, value):
            guard let value else { return String(describing: value) }
            return "\(value)"
        }
    }

    fileprivate func asSystemMessageParameter() -> SystemLogger.Parameter {
        return (isSensitive, key, value)
    }
}

// MARK: - Message

public extension Logger {
    struct Message {
        public let body: Body
        public let parameter1: Parameter?
        public let parameter2: Parameter?
        public let parameter3: Parameter?
    }
}

public extension Logger.Message {
    init(
        _ body: Body,
        _ parameter1: Parameter? = nil,
        _ parameter2: Parameter? = nil,
        _ parameter3: Parameter? = nil
    ) {
        self.body = body
        self.parameter1 = parameter1
        self.parameter2 = parameter2
        self.parameter3 = parameter3
    }
}

// MARK: - Logger

public final class Logger {
    // MARK: - Private Properties

    private let logger: SystemLogger
    private let category: String

    // MARK: - Lifecycle

    public init(bundle: Bundle, category: String) {
        let subsystem = bundle.bundleIdentifier ?? ""
        if #available(iOS 14.0, *) {
            logger = os.Logger(subsystem: subsystem, category: category)
        } else {
            logger = os.OSLog(subsystem: subsystem, category: category)
        }
        self.category = category
    }

    public convenience init(bundle: Bundle = .main, category: Category) {
        self.init(bundle: bundle, category: category.rawValue)
    }

    public convenience init<T: RawRepresentable>(bundle: Bundle, category: T) where T.RawValue == String {
        self.init(bundle: bundle, category: category.rawValue)
    }

    // MARK: - Public Methods

    public func log(_ message: @autoclosure () -> Message) {
        guard isCategoryOnSilentMode() == false else { return }

        let message = message()

        logger.log(
            message.body.value,
            ofType: message.body.asSystemMessageType(),
            message.parameter1?.asSystemMessageParameter(),
            message.parameter2?.asSystemMessageParameter(),
            message.parameter3?.asSystemMessageParameter()
        )
    }

    public func log(
        _ messageBody: @autoclosure () -> Message.Body,
        _ param1: @autoclosure () -> Message.Parameter? = nil,
        _ param2: @autoclosure () -> Message.Parameter? = nil,
        _ param3: @autoclosure () -> Message.Parameter? = nil
    ) {
        guard isCategoryOnSilentMode() == false else { return }
        let message = Message(messageBody(), param1(), param2(), param3())
        log(message)
    }
}

// MARK: - Private Methods

private extension Logger {
    func isCategoryOnSilentMode() -> Bool {
        return UserDefaults.standard.bool(forKey: "logging-silence-\(category)")
    }
}

// MARK: - System Message Type

private enum SystemMessageType {
    case debug
    case notice
    case info
    case error
}

private extension SystemMessageType {
    var prefix: String {
        switch self {
        case .debug:
            return "🛠"

        case .notice:
            return "💬"

        case .info:
            return "⚠️"

        case .error:
            return "⛔️"
        }
    }

    func asOSLogType() -> OSLogType {
        switch self {
        case .debug:
            return .debug

        case .notice:
            return .default

        case .info:
            return .info

        case .error:
            return .error
        }
    }
}

// MARK: - SystemLogger

private protocol SystemLogger {
    // swiftlint:disable:next large_tuple
    typealias Parameter = (isSensitive: Bool, key: String, value: String)

    func log(
        _ message: String,
        ofType type: SystemMessageType,
        _ param1: Parameter?,
        _ param2: Parameter?,
        _ param3: Parameter?
    )
}

// MARK: - OS.Logger

@available(iOS 14.0, *)
extension os.Logger: SystemLogger {
    fileprivate func log(
        _ message: String,
        ofType type: SystemMessageType,
        _ param1: Parameter?,
        _ param2: Parameter?,
        _ param3: Parameter?
    ) {
        let messageBody = "\(type.prefix) \(message)"
        let logType = type.asOSLogType()
        if let param1, let param2, let param3 {
            log(messageBody, ofType: logType, param1, param2, param3)
        } else if let param1, let param2 {
            log(messageBody, ofType: logType, param1, param2)
        } else if let param1 {
            log(messageBody, ofType: logType, param1)
        } else {
            log(level: logType, "\(messageBody)")
        }
    }
}

@available(iOS 14.0, *)
private extension os.Logger {
    // swiftlint:disable:next function_body_length
    func log(
        _ message: String,
        ofType type: OSLogType,
        _ param1: Parameter,
        _ param2: Parameter,
        _ param3: Parameter
    ) {
        switch (param1.isSensitive, param2.isSensitive, param3.isSensitive) {
        case (false, false, false):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, align: .none, privacy: .public), \
                \(param2.key): \(param2.value, align: .none, privacy: .public), \
                \(param3.key): \(param3.value, align: .none, privacy: .public)
                """
            )

        case (true, false, false):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, privacy: .private), \
                \(param2.key): \(param2.value, privacy: .public), \
                \(param3.key): \(param3.value, privacy: .public)
                """
            )

        case (true, true, false):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, privacy: .private), \
                \(param2.key): \(param2.value, privacy: .private), \
                \(param3.key): \(param3.value, privacy: .public)
                """
            )

        case (true, true, true):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, privacy: .private), \
                \(param2.key): \(param2.value, privacy: .private), \
                \(param3.key): \(param3.value, privacy: .private)
                """
            )

        case (false, true, true):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, privacy: .public), \
                \(param2.key): \(param2.value, privacy: .private), \
                \(param3.key): \(param3.value, privacy: .private)
                """
            )

        case (false, false, true):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, privacy: .public), \
                \(param2.key): \(param2.value, privacy: .public), \
                \(param3.key): \(param3.value, privacy: .private)
                """
            )

        case (false, true, false):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, privacy: .public), \
                \(param2.key): \(param2.value, privacy: .private), \
                \(param3.key): \(param3.value, privacy: .public)
                """
            )

        case (true, false, true):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, privacy: .private), \
                \(param2.key): \(param2.value, privacy: .public), \
                \(param3.key): \(param3.value, privacy: .private)
                """
            )
        }
    }

    func log(
        _ message: String,
        ofType type: OSLogType,
        _ param1: Parameter,
        _ param2: Parameter
    ) {
        switch (param1.isSensitive, param2.isSensitive) {
        case (false, false):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, privacy: .public), \
                \(param2.key): \(param2.value, privacy: .public)
                """
            )

        case (true, false):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, privacy: .private), \
                \(param2.key): \(param2.value, privacy: .public)
                """
            )

        case (true, true):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, privacy: .private), \
                \(param2.key): \(param2.value, privacy: .private)
                """
            )

        case (false, true):
            log(
                level: type,
                """
                \(message), \
                \(param1.key): \(param1.value, privacy: .public), \
                \(param2.key): \(param2.value, privacy: .private)
                """
            )
        }
    }

    func log(
        _ message: String,
        ofType type: OSLogType,
        _ param: Parameter
    ) {
        switch param.isSensitive {
        case false:
            log(level: type, "\(message), \(param.key): \(param.value, privacy: .public)")

        case true:
            log(level: type, "\(message), \(param.key): \(param.value, privacy: .private)")
        }
    }
}

// MARK: - OS.OSLog

extension os.OSLog: SystemLogger {
    fileprivate func log(
        _ message: String,
        ofType type: SystemMessageType,
        _ param1: Parameter?,
        _ param2: Parameter?,
        _ param3: Parameter?
    ) {
        let messageBody = "\(type.prefix) \(message)"
        let logType = type.asOSLogType()
        if let param1, let param2, let param3 {
            os_log(
                logType,
                log: self,
                resolveMessageBodyPattern(param1, param2, param3),
                messageBody,
                param1.key,
                param1.value,
                param2.key,
                param2.value,
                param3.key,
                param3.value
            )
        } else if let param1, let param2 {
            os_log(
                logType,
                log: self,
                resolveMessageBodyPattern(param1, param2),
                messageBody,
                param1.key,
                param1.value,
                param2.key,
                param2.value
            )
        } else if let param1 {
            os_log(logType, log: self, resolveMessageBodyPattern(param1), messageBody, param1.key, param1.value)
        } else {
            os_log(logType, log: self, resolveMessageBodyPattern(), messageBody)
        }
    }
}

private extension os.OSLog {
    func resolveMessageBodyPattern(
        _ param1: Parameter,
        _ param2: Parameter,
        _ param3: Parameter
    ) -> StaticString {
        switch (param1.isSensitive, param2.isSensitive, param3.isSensitive) {
        case (false, false, false):
            return "%{public}@, %{public}@: %{public}@, %{public}@: %{public}@, %{public}@: %{public}@"

        case (true, false, false):
            return "%{public}@, %{public}@: %{private}@, %{public}@: %{public}@, %{public}@: %{public}@"

        case (true, true, false):
            return "%{public}@, %{public}@: %{private}@, %{public}@: %{private}@, %{public}@: %{public}@"

        case (true, true, true):
            return "%{public}@, %{public}@: %{private}@, %{public}@: %{private}@, %{public}@: %{private}@"

        case (false, true, true):
            return "%{public}@, %{public}@: %{public}@, %{public}@: %{private}@, %{public}@: %{private}@"

        case (false, false, true):
            return "%{public}@, %{public}@: %{public}@, %{public}@: %{public}@, %{public}@: %{private}@"

        case (false, true, false):
            return "%{public}@, %{public}@: %{public}@, %{public}@: %{private}@, %{public}@: %{public}@"

        case (true, false, true):
            return "%{public}@, %{public}@: %{private}@, %{public}@: %{public}@, %{public}@: %{private}@"
        }
    }

    func resolveMessageBodyPattern(_ param1: Parameter, _ param2: Parameter) -> StaticString {
        switch (param1.isSensitive, param2.isSensitive) {
        case (false, false):
            return "%{public}@, %{public}@: %{public}@, %{public}@: %{public}@"

        case (true, false):
            return "%{public}@, %{public}@: %{private}@, %{public}@: %{public}@"

        case (true, true):
            return "%{public}@, %{public}@: %{private}@, %{public}@: %{private}@"

        case (false, true):
            return "%{public}@, %{public}@: %{public}@, %{public}@: %{private}@"
        }
    }

    func resolveMessageBodyPattern(_ param1: Parameter) -> StaticString {
        switch param1.isSensitive {
        case true:
            return "%{public}@, %{public}@: %{private}@"

        case false:
            return "%{public}@, %{public}@: %{public}@"
        }
    }

    func resolveMessageBodyPattern() -> StaticString {
        return "%{public}@"
    }
}
