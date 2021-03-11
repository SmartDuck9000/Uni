//
//  UniversityCell.swift
//  Uni
//
//  Created by David Sarkisyan on 08/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

final class UniversityCell: UITableViewCell {
    
    var universityImage = UIImageView()
    
    var universityLabel = UILabel()
    
    func setupUniversityCell(university: University){
        let selectedCellview = UIView()
        selectedCellview.backgroundColor = UIColor(red: 28/256, green: 28/256, blue: 30/256, alpha: 1)
        self.selectedBackgroundView = selectedCellview
        
        setupUniversityLabel(university: university)
        setupUniversityImage(university: university)
    }
    
    func setupUniversityImage(university: University){
        
        self.addSubview(universityImage)
        
        let image = UIImage(named: "\(university.name).jpg")
        
        universityImage.contentMode = .scaleAspectFit
        
        universityImage.translatesAutoresizingMaskIntoConstraints = false
        
        universityImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        universityImage.leftAnchor.constraint(equalTo: universityLabel.rightAnchor).isActive = true
        universityImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        universityImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        universityImage.layer.cornerRadius = 15
        universityImage.image = image
        
    }
    
    func setupUniversityLabel(university: University){
        
        self.addSubview(universityLabel)
        
        self.universityLabel.numberOfLines = 0
        
        universityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        universityLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        universityLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1/3*self.frame.width).isActive = true
        universityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        universityLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        universityLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        universityLabel.textColor = .black
        universityLabel.layer.cornerRadius = 15
        universityLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        universityLabel.textAlignment = .center
        self.universityLabel.text = university.fullName
        
    }
    
      override func awakeFromNib() {
          super.awakeFromNib()
          
      }

      override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(false, animated: false)
      }
    
}
