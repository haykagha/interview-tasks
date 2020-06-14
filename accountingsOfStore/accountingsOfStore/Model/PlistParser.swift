//
//  PlistParser.swift
//  accountingsOfStore
//
//  Created by Admin on 6/14/20.
//  Copyright © 2020 Admin. All rights reserved.
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
    
//    
//    static func getDataComponents(date: Date) {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date)
//        guard let day = components.day else {return}
//        guard let month = components.month else {return}
//        guard let year = components.year else {return}
//        
//        print(" Day:\(day) Month:\(month) Year:\(year)")
//    }
}
