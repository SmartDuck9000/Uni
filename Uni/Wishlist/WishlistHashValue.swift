//
//  WishlistHashValue.swift
//  Uni
//
//  Created by David Sarkisyan on 31.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import RealmSwift


final class WishlistHashValue: Object{

    var hashArray = List<Int?>()
    
    convenience init(university: University ,department: Department) {
        self.init()
        self.hashArray = {()->List<Int?> in
            let hashArray = List<Int?>()
            var counter: Int = 0
            for _ in 0 ... Manager.shared.realm.objects(RealmObject.self).count{
                hashArray.append(counter)
                counter += 1
            }
            return hashArray
        }()
    }
}
