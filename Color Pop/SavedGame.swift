//
//  SavedGame.swift
//  Color Pop
//
//  Created by Austin Wells on 11/4/25.
//

import UIKit
import os.log

class SavedGame: NSObject, NSCoding {
    // MARK: Properties
    var name: String
    var score: Int
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("savedGame")
    
    // MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let score = "score"
    }
    
    // MARK: Initialization
    init?(name: String, score: Int) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.score = score
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(score, forKey: PropertyKey.score)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a saved score.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let score = aDecoder.decodeInteger(forKey: PropertyKey.score)
        
        // Must call designated initializer
        self.init(name: name, score: score)
    }
}
