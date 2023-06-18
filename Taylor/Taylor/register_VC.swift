//
//  register_VC.swift
//  Taylor
//
//  Created by mac on 2023/6/19.
//

import UIKit

class register_VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func click_login_button(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
