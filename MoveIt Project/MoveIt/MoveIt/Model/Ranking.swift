//
//  Ranking.swift
//  MoveIt
//
//  Created by Zi Xiong on 11/27/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import Foundation

class restaurantRanking {
    static let negativeKeyWords: [String] = ["pizza", "burger", "hotdog", "steak", "nachos", "pasta", "fry", "fried", "fries", "donut", "cake", "ice cream", "chocolate", "cream"]
    
    static let positiveKeyWords: [String] = ["salad", "soup", "vegetarian", "organic", "juice" ]
    
    static let fastFood: [String] = ["A&W Restaurants", "Arby's", "Auntie Anne's", "Burger King", "Carl's Jr.", "Chuck E. Cheese's", "Church's Chicken", "Cinnabon", "Dairy Queen", "Domino's Pizza", "Dunkin' Donuts", "Five Guys", "Hardee's", "Jollibee", "KFC", "Krispy Kreme", "Little Caesars", "Long John Silver's", "McDonald's", "Panda Express", "Papa John's Pizza", "The Pizza Company", "Pizza Hut", "Popeyes", "Quizno's", "Starbucks", "Subway", "Taco Bell", "TCBY", "Tim Hortons", "Wendy's", "Wingstop", "WingStreet"]
    
    static func getRankValue(_ rname: String) -> Int {
        let name = rname.lowercased()
        var rankValue = 0
        
        for fastFoodName in fastFood {
            if name.contains(fastFoodName) {
                rankValue -= 1
                break
            }
        }
        
        for unhealthyFood in negativeKeyWords {
            if name.contains(unhealthyFood) {
                rankValue -= 1
            }
        }
        
        for healthyFood in positiveKeyWords {
            if name.contains(healthyFood) {
                rankValue += 1
            }
        }
        
        return rankValue
    }
}

class mealRanking {
    static let constraints: [String: [Int]] = [
        "carbohydrates": [0, 100],
        "sugars": [0, 30],
        "calories": [100, 800],
        "fats": [0, 30]
    ]
    
    static var LikeFoods = [String]()
    static var DislikeFoods = [String]()
    
    static let negativeKeyWords: [String] = ["pizza", "burger", "hotdog", "steak", "nachos", "pasta", "fry", "fried", "fries", "donut", "cake", "ice cream", "chocolate", "cream"]
    
    static let positiveKeyWords: [String] = ["salad", "steam", "steamed", "grill", "grilled", "poach", "poached", "raw", "chicken", "broccoli"]
    
    static func getRankValue(_ foodName: String, _ nutrition: [String: Int]) -> Int {
        let name = foodName.lowercased()
        var rankValue = 0
        
        for (item, _) in constraints {
            if (nutrition[item] ?? 0) < constraints[item]![0] || (nutrition[item] ?? 0) > constraints[item]![1] {
                rankValue -= 1
            }
        }
        
        for LikeFood in LikeFoods {
            if name.contains(LikeFood) {
                rankValue += 5
                break
            }
        }
        
        for DislikeFood in DislikeFoods {
            if name.contains(DislikeFood) {
                rankValue -= 5
                break
            }
        }
        
        for unhealthyFood in negativeKeyWords {
            if name.contains(unhealthyFood) {
                rankValue -= 1
                break
            }
        }
        
        for healthyFood in negativeKeyWords {
            if name.contains(healthyFood) {
                rankValue += 1
            }
        }
        
        return rankValue
    }
}



































