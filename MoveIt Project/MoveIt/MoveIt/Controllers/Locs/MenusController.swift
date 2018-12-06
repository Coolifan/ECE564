//
//  MenusController.swift
//  MoveIt
//
//  Created by Haohong Zhao on 12/5/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import Firebase

class MenusController: UITableViewController {
    var menuList = [menuItem]()
    var firebaseRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseRef = Database.database().reference()
        fetchMenus(id: "ChIJzVzNJa7mrIkR-CNXwnvRH60")
    }
    
    fileprivate func fetchMenus(id: String) {
        firebaseRef.child("restaurants").child("\(id)/menu").observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? NSArray {
                value.forEach({ (item) in
                    if let item = item as? [String: Any] {
                        guard let cal = item["Calories"] as? Int,
                              let carb = item["Carbohydrates"] as? Int,
                              let fats = item["Fats"] as? Int,
                              let sugars = item["Sugars"] as? Int,
                              let name = item["item_name"] as? String,
                              let price = item["price"] as? String,
                              let url = item["url"] as? String else { return }
                        self.menuList.append(
                            menuItem(
                                name: name,
                                price: price,
                                carbohydrates: carb,
                                sugars: sugars,
                                calories: cal,
                                fats: fats,
                                imageUrl: url
                            )
                        )
                    }
                })
                
                DispatchQueue.main.async {
                    self.menuList.sort(by: { prev, next in
                        mealRanking.getRankValue(prev.name, prev.nutrition) > mealRanking.getRankValue(next.name, next.nutrition)
                    })
                    self.tableView.reloadData()
                }
            }
            else {
                print("No menus")
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
}

extension MenusController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuCell(style: .default, reuseIdentifier: nil)
        cell.menu = menuList[indexPath.row]
        return cell
    }
}
