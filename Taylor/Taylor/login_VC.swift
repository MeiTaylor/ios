//
//  login_VC.swift
//  Taylor
//
//  Created by mac on 2023/6/19.
//


import UIKit

class login_VC: UIViewController {
    @IBOutlet weak var error_label: UILabel!
    
    @IBOutlet weak var password_text: UITextField!
    @IBOutlet weak var username_text: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(error_label.text)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "success"{
            if let destination = segue.destination as?success_VC{
                destination.text = "登录成功"
                 
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "success"{
            
            if username_text==nil||username_text.text==""{
                error_label.text = "请输入用户名"
                return false
            }
            if password_text==nil||password_text.text==""{
                error_label.text = "请输入密码"
                return false
            }
            
            error_label.text = nil
            
            }
        
        
        return true
    }

}
