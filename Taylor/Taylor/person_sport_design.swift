//
//  person_sport_design.swift
//  Taylor
//
//  Created by mac on 2023/6/20.
//

import UIKit

class person_sport_design: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var selectedOption: String?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDropdownMenu" {
            let dropdownMenuViewController = segue.destination as! DropdownMenuViewController
            // do something with dropdownMenuViewController if necessary
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
