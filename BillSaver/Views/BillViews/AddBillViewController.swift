//
//  AddBillViewController.swift
//  BillSaver
//
//  Created by Hargun Bedi on 2019-12-17.
//  Copyright © 2019 Hargun Bedi. All rights reserved.
//

import UIKit
import UserNotifications


class AddBillViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,  UITextFieldDelegate {

    private let dataSource = ["None", "Weekly", "Monthly", "Quarterly", "Yearly"]
    private var rowSelect = "Weekly"
    
    @IBOutlet weak var billTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var display: UIView!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var addButton: UIButton!
    private var check = true
    
    var doneSaving: (() -> ())?
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        billTextField.delegate = self
        addButton.isEnabled = false
        datePicker.minimumDate = Calendar.current.date(byAdding: .day , value: 1, to: Date())
        display.layer.cornerRadius = 30
        display.layer.masksToBounds = true
        
        
        //datePicker.maximumDate = Calendar.current.date(byAdding: .year , value: 30, to: Date())
        // Do any additional setup after loading the view.
    }
    
//    func yes() {
//        self.check = true
//    }
//
//    func no() {
//        self.check = false
//    }
    
    func isNotificationsEnabled(completion:@escaping (Bool)->() ) {
        UNUserNotificationCenter.current().getNotificationSettings() { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)

            default:
                completion(false)
            }
        }
    }
    
    @IBAction func add(_ sender: UIButton) {
        
        //let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        isNotificationsEnabled {
            success in
         DispatchQueue.main.async {
        if (success == false) {
            let alertController = UIAlertController(title: "Settings", message: "This app requires notifications", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Ok", style: .default) { (_) -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, options: [:],  completionHandler: nil)
                }
            }
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
           
        let bill = Bill(context: PersistanceService.context)
            bill.title = self.billTextField.text!
            bill.date = self.datePicker.date
        bill.identifier = UUID().uuidString
            bill.reminderFrequency = self.rowSelect
        
        //let current = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        content.body = "Your \(bill.title!) bill is due today"
        content.sound  = .default
        var date = DateComponents()
        date.hour = 7
        date.minute = 30
        var repeater = true
    
        if (bill.reminderFrequency == "Weekly") {

            let weekDay = Calendar.current.component(.weekday, from: bill.date!)
            date.weekday = weekDay
            repeater = true
            
        }
        if (bill.reminderFrequency == "Monthly") {
            let day = Calendar.current.component(.day, from: bill.date!)
            date.day = day
            repeater = true
        }
        
        if (bill.reminderFrequency == "Quarterly") {
            let day = Calendar.current.component(.day, from: bill.date!)
            let quarter = Calendar.current.component(.quarter, from: bill.date!)
            date.day = day
            date.quarter = quarter
            repeater = true
        }

        if (bill.reminderFrequency == "Yearly") {
            let day = Calendar.current.component(.day, from: bill.date!)
            date.day = day
            let month = Calendar.current.component(.month, from: bill.date!)
            date.month = month
            let year = Calendar.current.component(.year, from: bill.date!)
            date.month = year
            repeater = true

        }
        if (bill.reminderFrequency == "None") {
            repeater = false
        }
       
            BillFunctions.createBill(billModel: bill)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeater)
        print(date)
        let request = UNNotificationRequest(identifier: bill.identifier!, content: content, trigger: trigger)
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        
        
        
        
            if let doneSaving = self.doneSaving {
            doneSaving()
        }
        
        
        PersistanceService.saveContext()
            self.dismiss(animated: true)
        }
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rowSelect = dataSource[row]
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //let text = (billTextField.text! as NSString).replacingCharacters(in: range, with: string)
    if billTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
     addButton.isEnabled = false
    } else {
     addButton.isEnabled = true
    }
     return true
    }
    
    
}
