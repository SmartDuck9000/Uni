//
//  DepartmentStruct.swift
//  Uni
//
//  Created by David Sarkisyan on 13/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation


struct Department {
    var name: String
    var minPoints: Int
    var fullName : String
    var subjects: [String]
    var followers: Int
    var link: String
    
    var dictionary : [String : Any]{
        return [
            "name" : name,
            "minPoints": minPoints,
            "fullName": fullName,
            "subjects": subjects,
            "followers": followers,
            "link": link
        ]
    }
}

extension Department: DocumentSerializable{
    init?(dictionary: [String: Any]){
        guard let name = dictionary["name"] as? String,
            let minPoints = dictionary["minPoints"] as? Int,
            let fullName = dictionary["fullName"] as? String,
            let subjects = dictionary["subjects"] as? [String],
            let followers = dictionary["followers"] as? Int,
            let link = dictionary["link"] as? String
            else { return nil }
        self.init(name: name, minPoints: minPoints,fullName : fullName, subjects: subjects, followers: followers, link: link)
    }
}
