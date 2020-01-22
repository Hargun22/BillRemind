//
//  AddBillViewController.swift
//  BillSaver
//
//  Created by Hargun Bedi on 2019-12-17.
//  Copyright © 2019 Hargun Bedi. All rights reserved.
//

import UIKit

class AddBillViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
        
    }
    
    
    @IBAction func add(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
