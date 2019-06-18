//
//  Item.swift
//  Todoey
//
//  Created by MacBook Pro on 6/17/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation

class Item: Codable {
    //item type can encode itself into a plist or into a JSON
    //because it's encodable all of its properties must be standard data types
    
    
    //MARK: Properties
    var title: String = ""
    var done: Bool = false
    
    
}
