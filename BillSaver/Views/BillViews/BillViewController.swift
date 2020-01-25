//
//  BillViewController.swift
//  BillSaver
//
//  Created by Hargun Bedi on 2019-11-20.
//  Copyright © 2019 Hargun Bedi. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class BillViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
//
//
//        BillFunctions.readBills(completion: { [weak self] in
//
//            self?.tableView.reloadData()
//
//        })
        
        // MARK: Figure out giving uuid to notifications
        
        
        
        let fetchRequest: NSFetchRequest<Bill> = Bill.fetchRequest()
        
        do {
            
            let bills = try PersistanceService.context.fetch(fetchRequest)
            Data.billModels = bills
            self.tableView.reloadData()
        } catch {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddBills" {
            let popup = segue.destination as! AddBillViewController
            popup.doneSaving = { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.billModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil){
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = Data.billModels[indexPath.row].title
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        cell!.detailTextLabel?.text = formatter.string(from: Data.billModels[indexPath.row].date!)
        
        //print(Data.billModels[indexPath.row].date!)
        
        if (Calendar.current.isDateInTomorrow(Data.billModels[indexPath.row].date!) == true || Calendar.current.isDateInToday(Data.billModels[indexPath.row].date!) == true ){
            cell!.detailTextLabel?.textColor = UIColor.red
            cell?.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
        let date = Date()
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        let currentday = Calendar.current.date(byAdding: .day, value: 0, to: date)
        let checkDatecomp = Calendar.current.dateComponents([.year, .month, .day], from: Data.billModels[indexPath.row].date!)
        let checkDate = Calendar.current.date(from: checkDatecomp)
        
        if(Data.billModels[indexPath.row].reminderFrequency == "None"){
        if (Data.billModels[indexPath.row].date! > newDate!) {
            cell!.textLabel?.textColor = UIColor.red
            cell!.detailTextLabel?.textColor = UIColor.red
            cell?.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            cell!.detailTextLabel?.text = "Expired on: \(formatter.string(from: Data.billModels[indexPath.row].date!))"
        }
        }
        if(Calendar.current.isDateInToday(Data.billModels[indexPath.row].date!) == true) {
                       cell!.detailTextLabel?.textColor = UIColor.red
                       cell?.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                       cell!.detailTextLabel?.text = "Due Today"
                   }
        
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: @escaping  (Bool) -> ()) in
            
            let alert = UIAlertController(title: "Delete Bill", message: "Are you sure you want to delete?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                actionPerformed(false)
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
                print(Data.billModels[indexPath.row].identifier!)
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Data.billModels[indexPath.row].identifier!])
                PersistanceService.context.delete(Data.billModels[indexPath.row])
                BillFunctions.deleteBill(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                PersistanceService.saveContext()
                actionPerformed(true)
                
                
                
//                let center = UNUserNotificationCenter.current()
//                center.getPendingNotificationRequests(completionHandler: { requests in
//                    for request in requests {
//                        print(request)
//                    }
//                })
            }))
            
            self.present(alert, animated: true)
            
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
