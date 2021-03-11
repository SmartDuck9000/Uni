//
//  WishlisObject.swift
//  Uni
//
//  Created by David Sarkisyan on 05.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmObject: Object{
    
    @objc dynamic var departmentFullName: String = ""
    @objc dynamic var universityName: String = ""
    @objc dynamic var minPoints: Int = 0
    @objc dynamic var facultyFullName: String = ""
    var subjects = List<String?>()
    
    convenience init(university: University ,department: Department, faculty: Faculty) {
        self.init()
        self.departmentFullName = department.fullName
        self.facultyFullName = faculty.fullName
        self.universityName = university.name
        self.minPoints = department.minPoints  // помечается -1 когда объект удален в оффлайне, чтобы при появлении сети удалить его из бд
        self.subjects = {()->List<String?> in
            let subjectsList = List<String?>()
            for subject in department.subjects{
                subjectsList.append(subject)
            }
            if (5 - department.subjects.count) != 0{
                for _ in department.subjects.count ... 5{
                    subjectsList.append(nil)
                }
            }
            return subjectsList
        }()
    }
}
