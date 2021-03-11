//
//  SortStruct.swift
//  Uni
//
//  Created by David Sarkisyan on 22.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation

struct Sort {
    
    static var shared = Sort()
    
    enum Occasions: String, CaseIterable{
        case defaultSort = "По интересам"
        case minPointAscending = "По баллам (возрастанию)"
        case minPointDescending = "По баллам (убыванию)"
    }
    
    enum DefaultSort {
        case technical
        case humanitarian
        case natural
    }
    
    func switchDefaultSort(type: String) -> [String]?{
        switch type {
        case "Гуманитарные науки":
            return ["история", "география","литература","английский язык", "обществознание"]
        case "Технические науки":
            return ["физика", "математика", "информатика"]
        case "Естественные науки":
            return ["химия","биология","физика"]
        default:
            return nil
        }
        
    }
    
}

