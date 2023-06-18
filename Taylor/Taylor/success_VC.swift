//
//  success_login_VC.swift
//  Taylor
//
//  Created by mac on 2023/6/19.
//

import UIKit

class success_VC: UIViewController {

    var text = ""
    
    @IBAction func click_exit(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBOutlet weak var text_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        text_label.text = text
        
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
