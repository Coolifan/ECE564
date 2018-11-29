//
//  SettingsController.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/2/18.
//  Modified by Wenchao Zhu, Yifan Li and Zi Xiong on 11/27/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import UserNotifications
import Eureka
import Firebase


class SettingsController: FormViewController {
    var firebaseRef: DatabaseReference!
    
    var formData: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseRef = Database.database().reference()
        
        initSettings()
        
        form +++ Section("Profile")
            <<< TextRow(){ row in
                row.tag = "Name"
                row.title = "Name"
                row.placeholder = "Enter your name here"
                }.onChange({ row in
                    self.update(key: "Name", value: row.value  ?? "")
                    Settings.userName = row.value ?? "Ric"
                })
            <<< DecimalRow(){ row in
                row.tag = "Height(m)"
                row.title = "Height(m)"
                row.placeholder = "Enter your height here"
                }.onChange({ row in
                    self.update(key: "Height(m)", value: String(row.value ?? 0))
                })
            <<< DecimalRow(){ row in
                row.tag = "Weight(kg)"
                row.title = "Weight(kg)"
                row.placeholder = "Enter your weight here"
                }.onChange({ row in
                    self.update(key: "Weight(kg)", value: String(row.value  ?? 0))
                })
            <<< IntRow(){ row in
                row.tag = "Age"
                row.title = "Age"
                row.placeholder = "Enter your goal here"
                }.onChange({ row in
                    self.update(key: "Age", value: String(row.value ?? 0))
                })
            
            +++ Section("Goal")
            <<< IntRow(){ row in
                row.tag = "Daily Step"
                row.title = "Daily Step"
                row.placeholder = "Enter your daily step goal here"
                }.onChange({ row in
                    self.update(key: "Daily Step", value: String(row.value ?? 0))
                    Settings.dailySteps = row.value ?? 3000
                })
            <<< IntRow(){ row in
                row.tag = "Calories"
                row.title = "Calories"
                row.placeholder = "Enter your daily calorie goal here"
                }.onChange({ row in
                    self.update(key: "Calories", value: String(row.value ?? 0))
                })
            <<< DecimalRow(){ row in
                row.tag = "Goal Weight"
                row.title = "Goal Weight"
                row.placeholder = "Enter your goal weight here"
                }.onChange{ row in
                    self.update(key: "Goal Weight", value: String(row.value ?? 0))
                }
            
            +++ Section("Personal Preference")
            <<< IntRow(){ row in
                row.tag = "max walk distance"
                row.title = "max walk distance"
                row.placeholder = "Enter here"
                }.onChange({ row in
                    self.update(key: "max walk distance", value: String(row.value ?? 0))
                })
            <<< IntRow(){ row in
                row.tag = "max walk time"
                row.title = "max walk time"
                row.placeholder = "Enter here"
                }.onChange({ row in
                    self.update(key: "max walk time", value: String(row.value ?? 0))
                })
            <<< TextRow(){ row in
                row.tag = "favorite food"
                row.title = "favorite food"
                row.placeholder = "Enter here"
                }.onChange({ row in
                    self.update(key: "favorite food", value: row.value ?? "")
                })
            <<< TextRow(){ row in
                row.tag = "hated food"
                row.title = "hated food"
                row.placeholder = "Enter here"
                }.onChange { row in
                    self.update(key: "hated food", value: row.value ?? "")
                }
                
            +++ Section("Notification Settings")
            <<< TimeRow(){ row in
                row.tag = "Breakfast"
                row.title = "Breakfast"
                row.value = Date()
                }.onChange{ row in
                    self.formData["BreakfastHour"] = String(row.value!.toString(dateFormat: "HH"))
                    self.formData["BreakfastMinute"] = String(row.value!.toString(dateFormat: "mm"))
                    self.scheduledtime(identifier: "Breakfast", dateSet: row.value!)
                    self.update(key: "Breakfast hour", value: String(row.value!.toString(dateFormat: "HH")))
                    self.update(key: "Breakfast minute", value: String(row.value!.toString(dateFormat: "mm")))
                    print("changed")
                }
            <<< TimeRow(){ row in
                row.tag = "Lunch"
                row.title = "Lunch"
                row.value = Date()
                }.onChange{ row in
                    self.formData["LunchHour"] = String(row.value!.toString(dateFormat: "HH"))
                    self.formData["LunchMinute"] = String(row.value!.toString(dateFormat: "mm"))
                    self.scheduledtime(identifier: "Lunch", dateSet: row.value!)
                    self.update(key: "Lunch hour", value: String(row.value!.toString(dateFormat: "HH")))
                    self.update(key: "Lunch minute", value: String(row.value!.toString(dateFormat: "mm")))
                }
            <<< TimeRow(){ row in
                row.tag = "Dinner"
                row.title = "Dinner"
                row.value = Date()
                }.onChange{ row in
                    self.formData["DinnerHour"] = String(row.value!.toString(dateFormat: "HH"))
                    self.formData["DinnerMinute"] = String(row.value!.toString(dateFormat: "mm"))
                    self.scheduledtime(identifier: "Dinner", dateSet: row.value!)
                    self.update(key: "Dinner hour", value: String(row.value!.toString(dateFormat: "HH")))
                    self.update(key: "Dinner minute", value: String(row.value!.toString(dateFormat: "mm")))
                }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update(key: String, value: String){
        let path = "settings/" + key
        firebaseRef.child(path).setValue(value)
    }
    
    func initSettings() {
        firebaseRef.child("settings").observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? [String: String] {
                self.formData = value
                
                for row in self.form.rows {
                    let tag = row.tag!
                    let title = row.title!
                    
                    if row is TimeRow {
//                        let time = self.formData[title + " hour"]! + ":" + self.formData[title + " minute"]!
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "HH:mm"
//                        guard let timeData = dateFormatter.date(from: time) else {
//                            fatalError()
//                        }
//                        self.form.setValues(["\(tag)": timeData])
                    }
                    else if row is TextRow {
                        let value = self.formData[title]!
                        self.form.setValues(["\(tag)": value])
                    }
                    else if row is DecimalRow {
                        let value = self.formData[title]!
                        self.form.setValues(["\(tag)": Double(value)])
                    }
                    else if row is IntRow {
                        let value = self.formData[title]!
                        self.form.setValues(["\(tag)": Int(value)])
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            else {
                print("No settings")
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func scheduledtime(identifier: String, dateSet: Date) {
        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: dateSet)
//        let minutes = calendar.component(.minute, from: dateSet)
//        let seconds = calendar.component(.second, from: dateSet)
//        print("hours = \(hour):\(minutes):\(seconds)")
        let comp2 = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: dateSet)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp2, repeats: true)

        let content = UNMutableNotificationContent()
        switch identifier {
        case "Breakfast":
            content.title = "MoveIt Notification"
            content.subtitle = "Breakfast Reminder"
            content.body = "Hi \(Settings.userName), It's breakfast time!"
        case "Lunch":
            content.title = "MoveIt Notification"
            content.subtitle = "Lunch Reminder"
            content.body = "Hi \(Settings.userName), It's lunch time!"
        case "Dinner":
            content.title = "MoveIt Notification"
            content.subtitle = "Scheduled notification"
            content.body = "Hi \(Settings.userName), It's dinner time!"
        default:
            content.title = "MoveIt Notification"
            content.subtitle = "Meal Reminder"
            content.body = "Hi \(Settings.userName), It's time for meal!"
        }

        let request = UNNotificationRequest(
            identifier: "scheduled", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
