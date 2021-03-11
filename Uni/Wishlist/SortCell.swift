//
//  SortCell.swift
//  Uni
//
//  Created by David Sarkisyan on 01.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

final class SortCell: UITableViewCell {
    
    var title: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setCell(index: Int,occasions: [String]) {
        self.title = occasions[index]
    }
    
}
