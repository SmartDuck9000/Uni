//
//  WishlistCell.swift
//  Uni
//
//  Created by David Sarkisyan on 30.10.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

class WishlistCell: UITableViewCell {

    @IBOutlet weak var departmentNameLabel: UILabel!
    @IBOutlet weak var universityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setWishlistCell(wishedUniversity:  String, wishedDepartment: String){
        self.departmentNameLabel.text = wishedDepartment
        self.universityNameLabel.text = wishedUniversity
   }
    
}
