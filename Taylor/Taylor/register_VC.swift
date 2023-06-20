//
//  register_VC.swift
//  Taylor
//
//  Created by mac on 2023/6/19.
//

import UIKit

class register_VC: UIViewController {

    
    @IBOutlet weak var error_label: UILabel!
    
    @IBOutlet weak var password_text: UITextField!
    @IBOutlet weak var username_text: UITextField!
    
    @IBOutlet weak var phone_number: UITextField!
    
    @IBOutlet weak var living_address: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        error_label.text = ""
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "success"{
            if let destination = segue.destination as?success_VC{
                destination.text = "注册成功"
                 
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
            
        if identifier == "success" {
                
            if let username = username_text.text, !username.isEmpty,
                let password = password_text.text, !password.isEmpty {
                    let phoneNumber = phone_number.text
                    let livingAddress = living_address.text
                    let email = email.text
                    // Height and Weight not provided at registration.
                    if UserManager.shared.register(username: username, password: password, phoneNumber: phoneNumber, livingAddress: livingAddress, email: email) {
                       
                        let allUsers = UserManager.shared.getAllUsers()
                        for user in allUsers {
                            print("Username: \(user.0), Password: \(user.1), PhoneNumber: \(user.2 ?? "N/A"), LivingAddress: \(user.3 ?? "N/A"), Email: \(user.4 ?? "N/A"), Height: \(user.5 ?? "N/A"), Weight: \(user.6 ?? "N/A")")
                        }
                       
                        return true
                    } else {
                        error_label.text = "注册失败，可能是用户名已被注册"
                        return false
                    }
            } else {
                error_label.text = "请输入用户名和密码"
                return false
            }
        }
        
        error_label.text = ""
        return true
    }


    @IBAction func click_login_button(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
