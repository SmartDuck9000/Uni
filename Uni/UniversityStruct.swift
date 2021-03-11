//
//  File.swift
//  Uni
//
//  Created by David Sarkisyan on 05/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import Firebase

protocol  DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct University: Hashable {
    var name: String
    var city: String
    var militaryDepartment: Bool
    var dormitory: Bool
    var fullName: String
    
    var dictionary : [String : Any]{
        return [
            "name" : name,
            "fullName": fullName,
            "city" : city,
            "militaryDepartment" : militaryDepartment,
            "dormitory" : dormitory
        ]
      }
    }

extension University: DocumentSerializable{
    init?(dictionary: [String: Any]){
        guard let name = dictionary["name"] as? String,
            let city = dictionary["city"] as? String,
            let militaryDepartment = dictionary["militaryDepartment"] as? Bool,
            let dormitory = dictionary["dormitory"] as? Bool,
            let fullName = dictionary["fullName"] as? String
            else { return nil }
        
        self.init(name: name, city: city, militaryDepartment: militaryDepartment, dormitory: dormitory, fullName: fullName)
    }
}

