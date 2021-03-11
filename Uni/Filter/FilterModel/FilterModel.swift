//
//  Filter.swift
//  university
//
//  Created by Георгий Куликов on 19.10.2019.
//  Copyright © 2019 Георгий Куликов. All rights reserved.
//

import Foundation

struct subjectData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

struct Filter {
    var country: String?
    var subjects: [String]?
    var minPoint: Int?
    var military: Bool?
    var campus: Bool?
}
