//
//  DropdownMenuViewController.swift
//  Taylor
//
//  Created by mac on 2023/6/20.
//

import UIKit

class DropdownMenuViewController: UITableViewController {

    let dropdownOptions = ["千米", "米", "英里"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dropdownOptions[indexPath.row]
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selection
        print("User selected: \(dropdownOptions[indexPath.row])")
        self.dismiss(animated: true, completion: nil)
    }
}
