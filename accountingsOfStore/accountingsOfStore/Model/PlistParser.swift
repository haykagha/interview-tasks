//
//  PlistParser.swift
//  accountingsOfStore
//
//  Created by Hayk on 6/14/20.
//  Copyright © 2020 Hayk. All rights reserved.
//

import Foundation
import  UIKit

struct PlistParser {
    static func getPlist(withName name: String) -> [[String:AnyObject]]? {
        if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path)
        {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [[String:AnyObject]]
        }

        return nil
    }
    
}
