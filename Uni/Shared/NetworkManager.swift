//
//  File.swift
//  Uni
//
//  Created by David Sarkisyan on 26.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NetworkManager{
    
    let db = Firestore.firestore()
    
    private  init(){}
    
    static var shared = NetworkManager()
    
    let queue = DispatchQueue(label: "Not Main")
    let semaphore = DispatchSemaphore(value: 1)
    
    func loadUniversities(city: String?, subjects: [String]?, minPoints: Int?, dormitory: Bool?, militaryDepartment: Bool?, completion: ((_ currentUniversity: Int, _ allUniversitiesNumber: Int) -> Void)?){
        
        var minPoint: Int?
        if (minPoints == 0) || (minPoints == nil){
             minPoint = nil
        }else{  minPoint = minPoints}
        
        var checkedUniversitiesCounter: Int = 0
        var passedUniversitiesCounter: Int = 100
        
        Manager.shared.UFD.removeAll()
        
        db.collection("Universities")
            .getDocuments { (querySnapshot1, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                    completion?(0,0)
                }else{
                    passedUniversitiesCounter = 0
                    for university in (querySnapshot1?.documents)!{
                        checkedUniversitiesCounter += 1
                        if ( (university.data()["city"] as? String == city) || (city == nil) ) && ( (university.data()["militaryDepartment"] as? Bool == militaryDepartment) || (militaryDepartment == nil) || (militaryDepartment == false)  ) && ( (university.data()["dormitory"] as? Bool == dormitory) || (dormitory == nil) || (dormitory == false) ){
                            
                            passedUniversitiesCounter += 1
                            self.db.collection("Universities")
                                .document("\(university.documentID)")
                                .collection("\(university.data()["name"]!)faculties")
                                .getDocuments { (querySnapshot2, error) in
                                    if let error = error {
                                        print("\(error.localizedDescription)")
                                        completion?(0,0)
                                    }else{
                                        for faculty in (querySnapshot2?.documents)!{ // Сделать очередь на постепенные запросы к firebase (мб DispatchGroup либо очередь)
                                            self.db.collection("Universities")
                                                .document("\(university.documentID)")
                                                .collection("\(university.data()["name"]!)faculties")
                                                .document("\(faculty.documentID)")
                                                .collection("departments")
                                                .whereField("minPoints", isLessThanOrEqualTo: minPoint ?? 500)
                                                .getDocuments { (querySnapshot3, error) in
                                                    if let error = error {
                                                        print("\(error.localizedDescription)")
                                                        completion?(0,0)
                                                    } else{
                                                        for department in (querySnapshot3?.documents)!{
                                                            if (subjects == nil) ||  ((department.data()["subjects"] as? [String])?.sorted().contains(where: { (subject) -> Bool in
                                                                for filterSubject in (subjects?.sorted())!{
                                                                    if subject == filterSubject{
                                                                        return true
                                                                    }
                                                                }
                                                                return false
                                                            }))! {
                                                                Manager.shared.UFD[University(dictionary: university.data())!] = [:]
                                                            }
                                                        }
                                                        completion?(checkedUniversitiesCounter,(querySnapshot1?.documents)?.count ?? 0)
                                                    }
                                            }
                                        }
                                    }
                            }
                        } else if passedUniversitiesCounter == 0{
                            completion?(checkedUniversitiesCounter,(querySnapshot1?.documents)?.count ?? 0)
                        }
                    }
                }
        }
    }
        
        
    func loadFaculties(minPoints: Int?, subjects: [String]?, completion: (() -> Void)?) {
        
        var minPoint: Int?
        if (minPoints == 0) || (minPoints == nil){
             minPoint = nil
        }else{  minPoint = minPoints}
        
        db.collection("Universities")
            .document((Manager.shared.choosed[0] as! University).name)
            .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
            .getDocuments { (querySnapshot1, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                    completion?()
                } else{
                    for faculty in (querySnapshot1?.documents)!{
                        self.db.collection("Universities")
                            .document((Manager.shared.choosed[0] as! University).name)
                            .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                            .document("\(faculty.documentID)")
                            .collection("departments")
                            .whereField("minPoints", isLessThanOrEqualTo: minPoint ?? 500)
                            .getDocuments { (querySnapshot3, error) in
                                if let error = error {
                                    print("\(error.localizedDescription)")
                                    completion?()
                                }else{
                                    for department in (querySnapshot3?.documents)!{
                                        if (subjects == nil) ||  ((department.data()["subjects"] as? [String])?.sorted().contains(where: { (subject) -> Bool in
                                            for filterSubject in (subjects?.sorted())!{
                                                if subject == filterSubject{
                                                    return true
                                                }
                                            }
                                            return false
                                        }))!{
                                            Manager.shared.UFD[(Manager.shared.choosed[0] as! University)]?[Faculty(dictionary: faculty.data())] = []
                                        }
                                    }
                                    completion?()
                                }
                        }
                    }
                }
        }
    }
        
    func loadDepartments(subjects: [String]? ,minPoints: Int?, completion: (() -> Void)?) {
        var minPoint: Int?
        if (minPoints == 0) || (minPoints == nil){
             minPoint = nil
        }else{  minPoint = minPoints}
        
        db.collection("Universities")
            .document((Manager.shared.choosed[0] as! University).name)
            .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
            .document((Manager.shared.choosed[1] as! Faculty).fullName)
            .collection("departments")
            .whereField("minPoints", isLessThanOrEqualTo: minPoint ?? 500)
            .getDocuments { (querySnapshot, error) in
                var arrayOfDepartmnets = [Department]()
                if let error = error {
                    print("\(error.localizedDescription)")
                    completion?()
                }else{
                    for department in (querySnapshot?.documents)! {
                        if (subjects == nil) ||  ((department.data()["subjects"] as? [String])?.sorted().contains(where: { (subject) -> Bool in
                            for filterSubject in (subjects?.sorted())!{
                                if subject == filterSubject{
                                    return true
                                }
                            }
                            return false
                        }))!{
                            arrayOfDepartmnets.append(Department(dictionary: department.data())!)
                        }
                    }
                    Manager.shared.UFD[(Manager.shared.choosed[0] as! University)]?[(Manager.shared.choosed[1] as! Faculty)] =  arrayOfDepartmnets
                    completion?()
                }
        }
    }
    
    @objc func changeFollower(occasion: String, universityname: String,facultyFullName: String, departmentFullName: String) {  //occasion =  "add" или "remove"
        var difference: Int
        
        if occasion == "remove"{
            difference = -1
        }else{ difference = 1 }
        
        db.collection("Universities")
            .document(universityname)
            .collection("\(universityname)faculties")
            .document(facultyFullName)
            .collection("departments")
            .document(departmentFullName)
            .getDocument { (querySnapshot, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                }else{
                    if let data = querySnapshot!.data(){
                        let currentFollowers = data["followers"] as! Int
                        self.db.collection("Universities")
                            .document(universityname)
                            .collection("\(universityname)faculties")
                            .document(facultyFullName)
                            .collection("departments")
                            .document(departmentFullName)
                            .updateData(["followers": currentFollowers + difference]) { (error) in
                                if let error = error {
                                    print("\(error.localizedDescription)")
                                }else{
                                    print("Updating is completed")
                                }
                        }
                    }
                }
        }
    }
    
    func listenFollowers(universityName: String, facultyFullName: String, departmentFullName: String, completion: ((Int)-> Void)?){
        db.collection("Universities")
            .document(universityName)
            .collection("\(universityName)faculties")
            .document(facultyFullName)
            .collection("departments")
            .document(departmentFullName)
            .addSnapshotListener { (documentSnapshot, error) in
                if documentSnapshot?.data() != nil{
                let followers = documentSnapshot?.data()!["followers"] as! Int
                    completion?(followers)
                }
        }
    }
    
    
}
