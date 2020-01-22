//
//  BillModel.swift
//  BillSaver
//
//  Created by Hargun Bedi on 2019-11-03.
//  Copyright © 2019 Hargun Bedi. All rights reserved.
//

import Foundation

class BillModel {
    
    var title : String
    var date: Date
    var identifier: String
    var reminderFrequency: String
    
    
    init (title: String, date: Date, reminderFrequency: String){
        self.title = title
        self.date = date
        identifier = UUID().uuidString
        self.reminderFrequency = reminderFrequency
    }
    
}
