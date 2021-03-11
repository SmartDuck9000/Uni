//
//  FacultyStruct.swift
//  Uni
//
//  Created by David Sarkisyan on 10/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import Firebase

struct Faculty: Hashable {
    var name: String
    var fullName : String
    
    var dictionary : [String : Any]{
        return [
            "name" : name,
            "fullName": fullName,
        ]
    }
}
    

extension Faculty: DocumentSerializable{
        init?(dictionary: [String: Any]){
        guard let name = dictionary["name"] as? String,
              let fullName = dictionary["fullName"] as? String
            else { return nil }
            self.init(name: name,fullName : fullName)
    }
}

