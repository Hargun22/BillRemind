//
//  AppDelegate.swift
//  BillSaver
//
//  Created by Hargun Bedi on 2019-10-31.
//  Copyright © 2019 Hargun Bedi. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let fetchRequest: NSFetchRequest<Bill> = Bill.fetchRequest()
                      do {
                          let bills = try PersistanceService.context.fetch(fetchRequest)
                        var dateComponents = DateComponents()
                        dateComponents.hour = 7
                        dateComponents.minute = 30
                       
                          for reminders in bills {
                              let currentDate = Date()
                                let calendar = Calendar.current
                            
                            let currentHourMinute = calendar.dateComponents([.hour, .minute], from: currentDate)
                            let currentTime = calendar.date(from: currentHourMinute)
                            let remindTime = calendar.date(from: dateComponents)
                            if (reminders.reminderFrequency != "None") {
                                if ((currentDate == reminders.date! && currentTime! > remindTime! ) || currentDate > reminders.date! ) {
                                if (reminders.reminderFrequency == "Weekly"){
                                  let newDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: reminders.date!)
                                  reminders.date = newDate
                                }
                                if (reminders.reminderFrequency == "Monthly"){
                                    let newDate = Calendar.current.date(byAdding: .month, value: 1, to: reminders.date!)
                                  reminders.date = newDate
                                }
                                if (reminders.reminderFrequency == "Yearly"){
                                    let newDate = Calendar.current.date(byAdding: .year, value: 1, to: reminders.date!)
                                  reminders.date = newDate
                                }
                                }
                              }
                          }
                          PersistanceService.saveContext()
                      } catch {
                          
                      }
                      
                  }
        
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
 
      

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        PersistanceService.saveContext()
    }
    

}

