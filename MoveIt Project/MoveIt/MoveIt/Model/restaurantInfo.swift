//
//  restaurantInfo.swift
//  MoveIt
//
//  Created by Zi Xiong on 11/27/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import Foundation

struct menuItem {
    var name: String!
    var price: String?
    var nutrition = [String: Int]()
    
    init(name: String,
         price: String? = nil,
         carbohydrates: Int?,
         sugars: Int?,
         calories: Int?,
         fats: Int?) {
        
        self.name = name
        self.price = price ?? nil
        nutrition["carbohydrates"] = carbohydrates
        nutrition["sugars"] = sugars
        nutrition["calories"] = calories
        nutrition["fats"] = fats
    }
}


class restaurantInfo {
    var menu: [menuItem]
    var address: String
    var phone: String
    var website: String
    
    init(menu: [menuItem], address: String, phone: String, website: String) {
        self.menu = menu
        self.address = address
        self.phone = phone
        self.website = website
    }
}
