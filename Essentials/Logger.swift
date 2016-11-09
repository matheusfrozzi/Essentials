//
//  Logger.swift
//
//  Created by Nick Steinhauer on 4/11/16.
//  Copyright (c) 2016 Nick Steinhauer. All rights reserved.
//

import Foundation

/**
 
    The Logging protocol provides a common interface for conforming objects to log anything,
    by providing overloaded methods of several value or reference types.
 
 */
public protocol Logging {
    //
    var logger: Logger { get }

    func debugLog<T>(message: T) where T: Any
    func debugLog<T>(message: T) where T: Strideable
    func debugLog(message: String)
    
    func warnLog<T>(message: T) where T: Any
    func warnLog<T>(message: T) where T: Strideable
    func warnLog(message: String)
    
    func errorLog<T>(message: T) where T: Any
    func errorLog<T>(message: T) where T: Strideable
    func errorLog(message: String)
    
}

public extension Logging {
    
    /// The Logger helper instance, responsible for carrying out the logging.
    /// A new instance is provided lazily whenever logging occurs.
    var logger: Logger {
        get {
            return Logger()
        }
    }
    
    /// Log data when in `debug` threshold level
    ///
    /// - parameters:
    ///     - message: The message to log. When the argument isn't a `String` or a `Strideable`, the argument's type is logged instead.
    func debugLog<T>(message: T) where T: Any {
        let level = logger.log(level: .debug)
        let model = level("\(Self.self)")
        model("\(message.self)")
    }
    /// Log data when in `debug` threshold level
    ///
    /// - parameters:
    ///     - message: The message to log. When the argument isn't a `String` or a `Strideable`, the argument's type is logged instead.
    func debugLog<T>(message: T) where T: Strideable {
        let level = logger.log(level: .debug)
        let model = level("\(Self.self)")
        model("\(message)")
    }
    /// Log data when in `debug` threshold level
    ///
    /// - parameters:
    ///     - message: The message to log. When the argument isn't a `String` or a `Strideable`, the argument's type is logged instead.
    func debugLog(message: String) {
        let level = logger.log(level: .debug)
        let model = level("\(Self.self)")
        model("\(message)")
    }
    /// Log data when in `warn` threshold level
    ///
    /// - parameters:
    ///     - message: The message to log. When the argument isn't a `String` or a `Strideable`, the argument's type is logged instead.
    func warnLog<T>(message: T) where T: Any {
        let level = logger.log(level: .warn)
        let model = level("\(Self.self)")
        model("\(message.self)")
    }
    /// Log data when in `warn` threshold level
    ///
    /// - parameters:
    ///     - message: The message to log. When the argument isn't a `String` or a `Strideable`, the argument's type is logged instead.
    func warnLog<T>(message: T) where T: Strideable {
        let level = logger.log(level: .warn)
        let model = level("\(Self.self)")
        model("\(message)")
    }
    /// Log data when in `warn` threshold level
    ///
    /// - parameters:
    ///     - message: The message to log. When the argument isn't a `String` or a `Strideable`, the argument's type is logged instead.
    func warnLog(message: String) {
        let level = logger.log(level: .warn)
        let model = level("\(Self.self)")
        model("\(message)")
    }
    /// Log data when in `error` threshold level
    ///
    /// - parameters:
    ///     - message: The message to log. When the argument isn't a `String` or a `Strideable`, the argument's type is logged instead.
    func errorLog<T>(message: T) where T: Any {
        let level = logger.log(level: .error)
        let model = level("\(Self.self)")
        model("\(message.self)")
    }
    /// Log data when in `error` threshold level
    ///
    /// - parameters:
    ///     - message: The message to log. When the argument isn't a `String` or a `Strideable`, the argument's type is logged instead.
    func errorLog<T>(message: T) where T: Strideable {
        let level = logger.log(level: .error)
        let model = level("\(Self.self)")
        model("\(message)")
    }
    /// Log data when in `error` threshold level
    ///
    /// - parameters:
    ///     - message: The message to log. When the argument isn't a `String` or a `Strideable`, the argument's type is logged instead.
    func errorLog(message: String) {
        let level = logger.log(level: .error)
        let model = level("\(Self.self)")
        model("\(message)")
    }
    
}

/**
 
    The Logger is a struct used for logging messages specific to
    a certain running configuration level.
 
    The 'threshold' property is set globally by the app bundle that
    utilizes the module.
 
    Each class or struct that should log messages either to the console
    should conform to the Logging protocol
 
 */
public struct Logger {
    
    public enum Level: Int {
        case debug = 0
        case warn
        case error
        case none
    }
    
    private static let LOG_FILE_NAME = "log"
    
    /// Sets the globally available logging `threshold` level.
    public static var threshold = Level.debug                                                                   //this is declared globally only once by an app
    
    /// Log console style messages
    ///
    /// - parameters:
    ///     - level: The level for this logging process. This argument is *enclosed in the mehods curried return function.
    ///
    /// - returns: A higher-order function, with the enclosed `level`, ready to be supplied with the `model` type and the actual log `message`.
    func log(level: Level) -> (String) -> (String) -> () {
        return { model in
            return { message in
                let log = "\(model): \(message)"
                if Logger.threshold.rawValue <= level.rawValue && Logger.threshold == .debug {                  //conditional can only go here, as the optional return value is only available at the end of the higher-order function
                    print(log)
                    self.write(log: log)
                } else {
                    self.write(log: log)
                }
            }
        }
    }
    
    /// Write custom log strings to log file
    ///
    /// - parameters:
    ///     - log: a `String` to write the the log file, which is located in the app's documents directory.
    public func write(log: String) {
        let fm = FileManager.default
        
        guard let documentDirectoryUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        
        let logFileUrl = documentDirectoryUrl.appendingPathComponent(Logger.LOG_FILE_NAME)
        var tmpLog: String                                                                                      //this is initialized either with the current log data in file, or directly from the log message sent in here when the log file is created from scratch
        if fm.fileExists(atPath: logFileUrl.path) {
            do {
                tmpLog = try String(contentsOf: logFileUrl)
                tmpLog += "\n\(log) \(dateString)"
            } catch {                                                                                           //if we are unable to grab the current log data, we create them from scratch
                tmpLog = "\n\(log) \(dateString)"
            }
        } else {
            tmpLog = "\n\(log) \(dateString)"
        }
        do {
            try tmpLog.write(to: logFileUrl, atomically: true, encoding: .utf8)
        } catch {
            print("Logger: Unable to write to log file.")
        }
    }
    
}
