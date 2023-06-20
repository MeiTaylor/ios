//
//  personal_info.swift
//  Taylor
//
//  Created by mac on 2023/6/20.
//

import UIKit

class personal_info: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!

    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let nickname = nicknameTextField.text ?? ""
                let phoneNumber = phoneNumberTextField.text
                let email = emailTextField.text
                let address = addressTextField.text
                let height = heightTextField.text
                let weight = weightTextField.text
                let password = "1"  // assuming the password is "1"

                UserManager.shared.register(username: nickname, password: password, phoneNumber: phoneNumber, livingAddress: address, email: email, height: height, weight: weight)
    }

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

           // Get the current username from UserDefaults
           let currentUsername = UserDefaults.standard.string(forKey: "currentUsername") ?? ""

           if let userInfo = UserManager.shared.getUserInfo(username: currentUsername) {
               nicknameTextField.text = "1"
               phoneNumberTextField.text = userInfo.2
               emailTextField.text = userInfo.3
               addressTextField.text = userInfo.4
               heightTextField.text = userInfo.5
               weightTextField.text = userInfo.6
           }
       }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
