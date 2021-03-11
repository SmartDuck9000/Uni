//
//  DataBase.swift
//  Uni
//
//  Created by David Sarkisyan on 29.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import Firebase



final class Database: UIViewController {     // ТУТ НИЧЕГО НЕ ТРОГАТЬ
    
    let university = UniversityDocument.university
    let faculty = FacultyDocument.faculty
    let department = DepartmentDocument.department
    
    override func viewDidLoad() {
        renameDepartments(university: "СПбГУ", oldName: "2ehbVf54nlD1U3mDQnzW")
        
//        addUniversity()
        
//        addFaculty()
//
//        addDepartment()
    }

    func rename(university: String, oldName: String){
        NetworkManager.shared.db.collection("Universities").document(oldName).collection(university+"faculties").getDocuments(completion: { (documentSnapshot, error) in
            let data = documentSnapshot?.documents;
            for i in 0...data!.count - 1{
                NetworkManager.shared.db.collection("Universities").document(university).collection("\(university)faculties").document(data![i].data()["fullName"] as! String).setData(data![i].data())
            }
//            NetworkManager.shared.db.collection("Universities").document(oldName).delete()
        })
    }
    
    func renameDepartments(university: String, oldName: String){
        NetworkManager.shared.db.collection("Universities").document(oldName).collection(university+"faculties").getDocuments(completion: { (documentSnapshot, error) in
            let data = documentSnapshot?.documents;
            for i in 0...data!.count - 1{
           NetworkManager.shared.db.collection("Universities").document(oldName).collection(university+"faculties").document(data![i].documentID).collection((data![i].data()["name"] as! String) + "departments").getDocuments { (querySnapshot, error) in
                    let data2 = querySnapshot?.documents;
                    for j in 0...data2!.count - 1{
                        NetworkManager.shared.db.collection("Universities").document(university).collection("\(university)faculties").document(data![i].data()["fullName"] as! String).collection("departments").document(data2![j].data()["fullName"] as! String).setData(data2![j].data())
                    }
                }
            }
            //            NetworkManager.shared.db.collection("Universities").document(oldName).delete()
        })
    }
    
    func addUniversity(){
        NetworkManager.shared.db.collection("Universities").document(university.name).setData([
            "name": university.name,
            "fullName": university.fullName,
            "city": university.city,
            "dormitory": university.dormitory,
            "militaryDepartment": university.militaryDepartment
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }
    
    
    func addFaculty(){
        NetworkManager.shared.db.collection("Universities").document(university.name).collection("\(university.name)faculties").document(faculty.fullName).setData([
                "name": self.faculty.name,
                "fullName": self.faculty.fullName
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    }
                }
    }

    
    func addDepartment(){
        NetworkManager.shared.db.collection("Universities").document(university.name).collection("\(university.name)faculties").document(faculty.fullName).collection("departments").document(department.fullName).setData( [
            "name": self.department.name,
            "fullName": self.department.fullName,
            "link": self.department.link,
            "minPoints": self.department.minPoints,
            "subjects": self.department.subjects,
            "followers": self.department.followers
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }


}
