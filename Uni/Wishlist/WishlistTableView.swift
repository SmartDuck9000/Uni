//
//  WishlistTableView.swift
//  Uni
//
//  Created by David Sarkisyan on 30.10.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

class WishlistTableView1: UITableViewController {
    
    @IBOutlet weak var tableV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfDepartments = Int()
        for university in Manager.shared.wishlist.keys{
            numberOfDepartments +=  Manager.shared.wishlist[university]?.values.count ?? 0
        }
        return numberOfDepartments
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wishedUniversity = Array(Manager.shared.wishlist.keys)[indexPath.row ]
        let wishedFaculty = Array(Manager.shared.wishlist[wishedUniversity]!.keys)[indexPath.row]
        let wishedDepartment = (Manager.shared.wishlist[wishedUniversity]?[wishedFaculty])![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishlistCell", for: indexPath) as! WishlistCell
        cell.setWishlistCell(wishedUniversity: wishedUniversity, wishedDepartment: wishedDepartment)
        return cell
    }
}
