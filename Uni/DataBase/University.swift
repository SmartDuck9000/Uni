//
//  University.swift
//  Uni
//
//  Created by David Sarkisyan on 29.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation


struct UniversityDocument {
    
    static let university = UniversityDocument()
    
    let name: String = "СПбГУ"                      // Короткое название универа (например МГТУ)
    
    let fullName: String = "Test"                  // Полное имя
    
    let dormitory: Bool = true                 // Наличие общежития
    
    let militaryDepartment: Bool = false       // Наличие военной кафедры
    
    let city: String = "Test"                      // Город в котором университет (писать также как и города в фильтрах)
    
}
