//
//  Dream.swift
//  Ghost's Dreams
//
//  Created by Smsma Mac on 12/10/18.
//  Copyright © 2018 Samar Khaled. All rights reserved.
//

import UIKit
import os.log

class Dream: NSObject, NSCoding {
    
    //MARK: - Properties
    var dreamTitle: String
    var dreamDescription: String?
    
    //MARK: - Initalization
    
    init?(title: String, description: String?) {
        
        guard !title.isEmpty else {
            return nil
        }
    
        self.dreamTitle = title
        self.dreamDescription = description
        
    }
    
    //MARK: - NSCoding
    
    struct PropertyType {
        static let title = "title"
        static let description = "description"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dreamTitle, forKey: PropertyType.title)
        aCoder.encode(dreamDescription, forKey: PropertyType.description)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let title = aDecoder.decodeObject(forKey: PropertyType.title) as? String else {
            os_log("Unable to decode the title", log: OSLog.default, type: .debug)
            return nil
        }
        let description = aDecoder.decodeObject(forKey: PropertyType.description) as? String
        
        self.init(title: title, description: description)
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Dreams")
 
    
    
}
