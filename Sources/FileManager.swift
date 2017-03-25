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
    
    /// Get the next available URL for a particular `filename` in a specific directory.
    ///
    /// The method is executed in a recursive manner appending the value `" copy"` in each
    /// iteration, until a non existing URL is found.
    ///
    /// - parameters:
    ///     - filename: The filename.
    ///     - fileExtension: The file extension to attach to the filename.
    ///     - directory: A valid directory URL. The parameter will be checked for existence and if it is an actual directory. Otherwise a `FilenameError` will be thrown.
    ///
    /// - throws: a `FilenameError`.
    public func url(withFilename filename: String, extension fileExtension: String, in directory: URL) throws -> URL {
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
            fileUrl = try url(withFilename: filename.suffix(" copy"), extension: fileExtension, in: directory)
        }
        return fileUrl
    }
    
    /// Get the next available URL for a particular `filename` in a specific directory.
    ///
    /// The implematation calls `url(withFilename:extension:in:) throws -> _` passing an
    /// empty string as the extension.
    public func url(withFilename filename: String, in directory: URL) throws -> URL {
        return try url(withFilename: filename, extension: "", in: directory)
    }
}
