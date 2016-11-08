//
//  Logger.swift
//
//  Created by Nick Steinhauer on 4/11/16.
//  Copyright (c) 2016 Nick Steinhauer. All rights reserved.
//

import Foundation

/*
 *  The Logging protocol provides a common interface
 *  for conforming objects to log anything, by providing
 *  overloaded methods of several value or reference types.
 */
public protocol Logging {
    
    var logger: Logger { get }
    
    func debugLog<T>(any: T) where T: Any
    func debugLog<T>(strideable: T) where T: Strideable
    func debugLog(message: String)
    
    func warnLog<T>(any: T) where T: Any
    func warnLog<T>(strideable: T) where T: Strideable
    func warnLog(message: String)
    
    func errorLog<T>(any: T) where T: Any
    func errorLog<T>(strideable: T) where T: Strideable
    func errorLog(message: String)
    
}

public extension Logging {
    
    /*
     *  A Logger instance is provided lazily whenever
     *  logging is supposed to take place.
     */
    var logger: Logger {
        get {
            return Logger()
        }
    }
    
    func debugLog<T>(any: T) where T: Any {
        let level = logger.log(level: .debug)
        let model = level("\(Self.self)")
        model("\(any.self)")
    }
    
    func debugLog<T>(strideable: T) where T: Strideable {
        let level = logger.log(level: .debug)
        let model = level("\(Self.self)")
        model("\(strideable)")
    }
    
    func debugLog(message: String) {
        let level = logger.log(level: .debug)
        let model = level("\(Self.self)")
        model("\(message)")
    }
    
    func warnLog<T>(any: T) where T: Any {
        let level = logger.log(level: .warn)
        let model = level("\(Self.self)")
        model("\(any.self)")
    }
    
    func warnLog<T>(strideable: T) where T: Strideable {
        let level = logger.log(level: .warn)
        let model = level("\(Self.self)")
        model("\(strideable)")
    }
    
    func warnLog(message: String) {
        let level = logger.log(level: .warn)
        let model = level("\(Self.self)")
        model("\(message)")
    }
    
    func errorLog<T>(any: T) where T: Any {
        let level = logger.log(level: .error)
        let model = level("\(Self.self)")
        model("\(any.self)")
    }
    
    func errorLog<T>(strideable: T) where T: Strideable {
        let level = logger.log(level: .error)
        let model = level("\(Self.self)")
        model("\(strideable)")
    }
    
    func errorLog(message: String) {
        let level = logger.log(level: .error)
        let model = level("\(Self.self)")
        model("\(message)")
    }
    
}

/*
 *  The Logger is a struct used for logging messages specific to
 *  a certain running configuration level.
 *
 *  The 'threshold' property is set globally by the app bundle that
 *  utilizes the module.
 *
 *  Each class or struct that should log messages either to the console
 *  should conform to the Logging protocol
 */
public struct Logger {
    
    public enum Level: Int {
        case debug = 0
        case warn
        case error
        case none
    }
    
    private static let LOG_FILE_NAME = "log"
    
    public static var threshold = Level.debug                                                                   //this is declared globally only once by an app
    
    /*
     *  Log console style messages
     */
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
    
    /*
     *  Write custom log strings to log file
     */
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
