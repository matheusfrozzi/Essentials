# Essentials

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Swift](https://img.shields.io/badge/swift-3.0.2-orange.svg)](https://swift.org)[![iOS](https://img.shields.io/badge/iOS-8.0-blue.svg)][![Swift](https://img.shields.io/badge/macOS-10.10-blue.svg)]

A framework of useful entities for iOS and macOS targets.

##Entities

###CoreDataStack

Universal Core Data Stack (singleton), ready to be used in iOS and macOS targets. The stack is setup with a main and a background (private) context that are utilised by a PersistentStoreContainer where applicable or, NSManagedObjectContextDidSave notifications are registered and handled manually.

###Rounder

Global function that rounds a `Double` at a certain number of decimal digits.

###FileManager

Foundation `FileManager` extension used for saving a similarly named file into a particular directory (similar to how macOS handles Finder file duplication.)

###String

Foundation `String` extension with helpful related methods.

###Logger

A univarsal Logger for iOS and macOS targets. Any logs are either stored to a file location or, both on disk and the console.

###SPM ready

Just add repo the link to your `Package.swift` file dependencies. 
