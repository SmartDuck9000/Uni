//
//  Department.swift
//  Uni
//
//  Created by David Sarkisyan on 29.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation

struct DepartmentDocument {
    
    static let department = DepartmentDocument()
    
    let name: String = "Test"          // Короткое название (например ИУ7)
    
    let fullName: String = "Test"      // Полное название
    
    let link: String = ""          // Просто ссылка по которой будет открываться в сафари
    
    let minPoints: Int = 0         // Минимальный проходной балл
    
    let subjects: [String] = [     // Надо ставить такие же названия как записаны в фильтрах (с маленькой буквы и другое)
    "математика",
    "русский",
    "физика"
    ]
    
    let followers: Int = 0         // ЭТО МЕНЯТЬ НЕ НАДО
    
}
