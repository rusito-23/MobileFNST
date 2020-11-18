//
//  Logger.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 9/2/19.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

let logger = Log()

extension Date {

    func toLoggerString() -> String {
        let loggerDateFormat = "yyyy-MM-dd HH:mm:ss"
        let loggerFormatter = DateFormatter()
        loggerFormatter.dateFormat = loggerDateFormat
        loggerFormatter.locale = Locale.current
        loggerFormatter.timeZone = TimeZone.current
        return loggerFormatter.string(from: self as Date)
    }

}

class Log {

    // MARK: Levels

    enum Level: String {
        case debug = "DEBUG 💬 "
        case verbose = "VERBOSE 🔬 "
        case info = "INFO ℹ️ "
        case warning = "WARNING ⚠️ "
        case severe = "SEVERE ‼️ "
        case error = "ERROR 🔥 "
    }

    // MARK: Utils

    private func getDate() -> String {
        return Date().toLoggerString()
    }

    private func sourceFileName(_ filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }

    func print(_ object: Any) {
        // Only allowing in DEBUG mode
        #if DEBUG
        Swift.print(object)
        #endif
    }

}

// MARK: Log methods

extension Log {

    // MARK: Debug
    func debug(_ object: Any,
               filename: String = #file,
               line: Int = #line,
               column: Int = #column,
               funcName: String = #function) {
        print("""
            \(getDate()) \(Level.debug.rawValue)[\(sourceFileName(filename))]:\
            \(line) \(column) \(funcName) -> \(object)"
            """)
    }

    // MARK: Info
    func info(_ object: Any,
              filename: String = #file,
              line: Int = #line,
              column: Int = #column,
              funcName: String = #function) {
        print("""
            \(getDate()) \(Level.info.rawValue)[\(sourceFileName(filename))]:\
            \(line) \(column) \(funcName) -> \(object)"
            """)
    }

    // MARK: Warning
    func warn(_ object: Any,
              filename: String = #file,
              line: Int = #line,
              column: Int = #column,
              funcName: String = #function) {
        print("""
            \(getDate()) \(Level.warning.rawValue)[\(sourceFileName(filename))]:\
            \(line) \(column) \(funcName) -> \(object)"
            """)
    }

    // MARK: Verbose
    func verbose(_ object: Any,
                 filename: String = #file,
                 line: Int = #line,
                 column: Int = #column,
                 funcName: String = #function) {
        print("""
            \(getDate()) \(Level.verbose.rawValue)[\(sourceFileName(filename))]:\
            \(line) \(column) \(funcName) -> \(object)"
            """)
    }

    // MARK: severe
    func severe(_ object: Any,
                filename: String = #file,
                line: Int = #line,
                column: Int = #column,
                funcName: String = #function) {
        print("""
            \(getDate()) \(Level.severe.rawValue)[\(sourceFileName(filename))]:\
            \(line) \(column) \(funcName) -> \(object)"
            """)
    }

    // MARK: error
    func error(_ object: Any,
               filename: String = #file,
               line: Int = #line,
               column: Int = #column,
               funcName: String = #function) {
        print("""
            \(getDate()) \(Level.error.rawValue)[\(sourceFileName(filename))]:\
            \(line) \(column) \(funcName) -> \(object)"
            """)
    }

    // MARK: request
    func request<T: Codable>(_ object: T,
                             url: String,
                             filename: String = #file,
                             line: Int = #line,
                             column: Int = #column,
                             funcName: String = #function) {

        let body = try? JSONEncoder().encode(object)
        let bodyString = body != nil ? String(data: body!, encoding: .utf8) : nil

        let message = """
            \(getDate()) \(Level.info.rawValue)[\(sourceFileName(filename))]:\
            \(line) \(column) \(funcName) ->
            =======================================
            Request: \(url)
            ---------------------------------------
            Body: (\(T.self))
            \(bodyString ?? "Failed to encode body.")
            =======================================
        """
        print(message)
    }

}
