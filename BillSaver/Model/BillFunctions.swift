//
//  BillFunctions.swift
//  BillSaver
//
//  Created by Hargun Bedi on 2019-11-03.
//  Copyright © 2019 Hargun Bedi. All rights reserved.
//

import Foundation

class BillFunctions {
    static func createBill(billModel: Bill) {
        Data.billModels.append(billModel)
    }
    
//    static func readBills(completion: @escaping () -> ()) {
//        
////            if (Data.billModels.count == 0) {
////                Data.billModels.append(BillModel(title: "Stove Bill", date: Date()))
////                Data.billModels.append(BillModel(title: "Fridge Bill", date: Date()))
////                Data.billModels.append(BillModel(title: "TV Bill", date: Date()))
////            }
////
//            
//            DispatchQueue.main.async {
//                completion()
//            }
//            
//
//        }
//
//
//    }
//    
//    static func updateBill(billModel: Bill) {
//
//    }
//
    static func deleteBill(index: Int) {
        Data.billModels.remove(at: index)
    }
}
