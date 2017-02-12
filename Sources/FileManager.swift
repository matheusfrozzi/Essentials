//
//  FileManager.swift
//  Essentials
//
//  Created by Nicolaos Steinhauer on 11/02/2017.
//
//

import Foundation

public extension FileManager {
    public enum FilenameError: Error {
        case nonExistingDirectory
        case notADirectory
    }
    
    /// Save a `filename` with a particular file extension to a specific directory.
    ///
    /// - parameters:
    ///     - filename: The filename.
    ///     - fileExtension: The file extension to attach to the filename.
    ///     - directory: A valid directory URL. The parameter will be checked for existence and if it is an actual directory. Otherwise a `FilenameError` will be thrown.
    ///
    /// - throws: a `FilenameError`.
    public func save(filename: String, extension fileExtension: String, to directory: URL) throws -> URL {
        let directoryPath = directory.path
        let expandedDirectoryPath = NSString(string: directoryPath).expandingTildeInPath
        var isDir = ObjCBool(false)
        //check directory exists
        guard fileExists(atPath: expandedDirectoryPath, isDirectory: &isDir) else { throw FilenameError.nonExistingDirectory }
        //check directory is in fact a directory
        guard isDir.boolValue else { throw FilenameError.notADirectory }
        //check file existence
        var fileUrl = directory.appendingPathComponent(filename).appendingPathExtension(fileExtension)
        if fileExists(atPath: fileUrl.path) {
            fileUrl = try save(filename: filename.suffix(" copy"), extension: fileExtension, to: directory)
        }
        return fileUrl
    }
    
    /// Save a `filename` to a specific directory.
    ///
    /// The implematation calls `save(_:_:_:) throws -> _`.
    public func save(filename: String, to directory: URL) throws -> URL {
        return try save(filename: filename, extension: "", to: directory)
    }
}
