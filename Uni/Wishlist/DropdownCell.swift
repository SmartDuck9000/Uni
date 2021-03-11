//
//  DropdownCell.swift
//  Uni
//
//  Created by David Sarkisyan on 26.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Alamofire

class DropdownCell: UITableViewCell{
    
    var cellExists: Bool = false
    
    let leftConstraint: CGFloat = 5
    
    var facultyFullNameLabel = UILabel()
    
    @objc var completionBlock: (() -> ())?
    
    @IBOutlet weak var open: UIButton!
    
    @IBOutlet weak var subjectsLabel: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    
    var minPointsLabel = UILabel()
    
    @IBAction func deleteButton(_ sender: UIButton){
        var objectToDelete: RealmObject = RealmObject()
        do {
            try Manager.shared.realm.write {
              objectToDelete = Manager.shared.realm.objects(RealmObject.self).filter("departmentFullName = '\((self.departmentNameLabel.text)!)'")[0]
            }
        } catch {
            print(error.localizedDescription)
        }
        Manager.shared.notificationCenter.post(Notification(name: Notification.Name(rawValue: "Department Deleted from wishlist")))
        Manager.shared.deleteFromWishlist(sender: nil, setImage: nil, departmentFullName: objectToDelete.departmentFullName)
        Manager.shared.wishlistQueue.async(execute: Manager.shared.workItem)
    }
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var mapButtonOutlet: UIButton!
    
    @IBAction func mapButton(_ sender: UIButton) {
        var department: RealmObject = RealmObject()
        
        do {
            try Manager.shared.realm.write {
                department = Manager.shared.realm.objects(RealmObject.self).filter("departmentFullName = '\((self.departmentNameLabel.text)!)'")[0]
            }
        } catch {
            print(error.localizedDescription)
        }
        
        for val in Manager.shared.UFD {
            if val.key.name == department.universityName {
                Manager.shared.openMaps(university: val.key)
                return
            }
        }
    }
    
    @IBOutlet weak var openView: UIView!
    
    @IBOutlet weak var departmentNameLabel: UILabel!
    
    @IBOutlet weak var universityName: UILabel!
    
    @IBOutlet weak var view: UIView!{
        didSet{
            view.isHidden = true
            view.alpha = 0
        }
    }
    
//    func checkCellExists() -> Bool{
//        let realmObjects = Array(Manager.shared.realm.objects(RealmObject.self).filter("minPoints != -1"))
//        
//        if realmObjects.contains(where: { (object) -> Bool in
//            return object.departmentFullName == self.departmentNameLabel.text
//        }){
//            return true
//        }else{ return false}
//    }
    
    func animate(duration:Double, c: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                self.view.isHidden = !self.view.isHidden
                if self.view.alpha == 1 {
                    self.view.alpha = 0.5
                } else {
                    self.view.alpha = 1
                }
            })
        }, completion: {  (finished: Bool) in
            c()
        })
    }
    
    func setWishlistCell(universityName: String, departmentFullName:String, facultyFullName: String, subjects: [String?], minPoints: Int ,cell: UITableViewCell) {
        
//        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
//        cell.layoutMargins = UIEdgeInsets.zero
        
        setOpenView(cell: cell)
        setView(cell: cell)
        setDeleteButton(universityname: universityName, facultyFullName: departmentFullName, departmentFullName: facultyFullName)
        setMapButton()
        setDepartmentLabel(departmentFullName: departmentFullName)
        setupFacultyLabel(facultyFullName: facultyFullName)
        setUniversityName(universityname: universityName)
        setSubjects(subjects: subjects)
        setFollowersLabel(departmentFullName: departmentFullName, universityName: universityName, facultyFullName: facultyFullName)
        setupMinPointsLabel(minPoints: minPoints)
        open.setTitle("", for: .normal)
    }
    
    func setupMinPointsLabel(minPoints: Int){
        view.addSubview(minPointsLabel)
        
        minPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        minPointsLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        minPointsLabel.textColor = .black
        minPointsLabel.text = "Проходной балл: \(minPoints)"
        
        minPointsLabel.topAnchor.constraint(equalTo: followers.bottomAnchor, constant: 5).isActive = true
        minPointsLabel.leftAnchor.constraint(equalTo: followers.leftAnchor).isActive = true
        minPointsLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        minPointsLabel.bottomAnchor.constraint(equalTo: mapButtonOutlet.topAnchor).isActive = true
    }
    
    func setDeleteButton(universityname: String, facultyFullName: String, departmentFullName: String){
        
        completionBlock = {
            NetworkManager.shared.changeFollower(occasion:"remove",universityname: universityname, facultyFullName: facultyFullName ,departmentFullName: departmentFullName)
        }
        
        deleteButton.addTarget(.none, action: #selector(myselector), for: .touchUpInside)
        
        deleteButton.layer.cornerRadius = 5
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.backgroundColor = UIColor.alizarin
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    @objc func myselector() {
        if let completion = completionBlock {
            completion()
        }
    }
    
    func setDepartmentLabel(departmentFullName: String){
        
        departmentNameLabel.translatesAutoresizingMaskIntoConstraints = false

        departmentNameLabel.topAnchor.constraint(equalTo: openView.topAnchor, constant: 2).isActive = true
        departmentNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        departmentNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        departmentNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        departmentNameLabel.centerYAnchor.constraint(equalTo: openView.centerYAnchor).isActive = true
        
        departmentNameLabel.numberOfLines = 0
        departmentNameLabel.textAlignment = .center
        departmentNameLabel.text = departmentFullName
        departmentNameLabel.textColor = UIColor.white
    }
    
    func setOpenView(cell: UITableViewCell){
        openView.frame = cell.bounds
        open.frame = openView.frame
        openView.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.size.width, height: cell.bounds.size.height)
        self.openView.backgroundColor = UIColor(red: 28/256, green: 28/256, blue: 30/256, alpha: 1)
    }
    
    func setView(cell: UITableViewCell){
        view.layer.masksToBounds = true
        
        view.frame = CGRect(x: openView.frame.minX, y: openView.frame.maxY, width: cell.bounds.size.width - 8, height: 210)
        view.frame.size.width = openView.frame.size.width
        view.backgroundColor = #colorLiteral(red: 0.9334822297, green: 0.9955082536, blue: 0.9193486571, alpha: 1)
    }
    
    func setUniversityName(universityname: String){
        
        universityName.translatesAutoresizingMaskIntoConstraints = false
        
        universityName.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        universityName.rightAnchor.constraint(equalTo: facultyFullNameLabel.leftAnchor).isActive = true
//        universityName.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        universityName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        universityName.centerYAnchor.constraint(equalTo: facultyFullNameLabel.centerYAnchor).isActive = true
        
        universityName.textAlignment = .center
        universityName.font = UIFont(name: "AvenirNext-Regular", size: 15)
        universityName.textColor = .black
        
        universityName.text = universityname
    }
    
    func setupFacultyLabel(facultyFullName: String){
        
        view.addSubview(facultyFullNameLabel)
        
        facultyFullNameLabel.font =  UIFont(name: "AvenirNext-Regular", size: 15)
        facultyFullNameLabel.numberOfLines = 0
        facultyFullNameLabel.textColor = .black
        facultyFullNameLabel.textAlignment = .center
        
        facultyFullNameLabel.text = facultyFullName
        
        facultyFullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        facultyFullNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        facultyFullNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        facultyFullNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        facultyFullNameLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
//        universityName.centerYAnchor.constraint(equalTo: facultyFullNameLabel.centerYAnchor).isActive = true // центрирование Label'ов
        
    }
    
    func setMapButton() {
        mapButtonOutlet.layer.cornerRadius = 5
        mapButtonOutlet.backgroundColor = UIColor(red: 106/256, green: 166/256, blue: 211/256, alpha: 1)
        mapButtonOutlet.setTitle("Построить маршрут", for: .normal)
        mapButtonOutlet.setTitleColor(.black, for: .normal)
        mapButtonOutlet.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 15)
        
        mapButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        
        mapButtonOutlet.topAnchor.constraint(equalTo: deleteButton.topAnchor).isActive = true
        mapButtonOutlet.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapButtonOutlet.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: -10).isActive = true
        mapButtonOutlet.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setSubjects(subjects: [String?]) {
        subjectsLabel.backgroundColor = view.backgroundColor
        subjectsLabel.numberOfLines = 5
        subjectsLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        subjectsLabel.textColor = .black
        subjectsLabel.text = {(subjects: [String?])->String in
            var text: String = "Предметы:"
            for string in  subjects{
                if string != nil{
                    text.append("\n\(string!)")
                }
            }
            return text
        }(subjects)

        subjectsLabel.translatesAutoresizingMaskIntoConstraints = false

        subjectsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftConstraint).isActive = true
        subjectsLabel.topAnchor.constraint(equalTo: facultyFullNameLabel.bottomAnchor, constant: 5).isActive = true
        subjectsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
//        subjectsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        subjectsLabel.rightAnchor.constraint(equalTo: mapButtonOutlet.leftAnchor).isActive = true
    }
    
    func setFollowersLabel(departmentFullName: String, universityName: String,facultyFullName: String){
        
        followers.backgroundColor = view.backgroundColor
        followers.font = UIFont(name: "AvenirNext-Regular", size: 15)
        setFollowersLabelAttributedText(departmentFullName: departmentFullName, universityName: universityName,facultyFullName: facultyFullName)
        
        Manager.shared.notificationCenter.addObserver(forName: NSNotification.Name(rawValue: "Internet Connection Status Changed"), object: .none, queue: .main) { (Notification) in // При первом запуске не выполняет код внутри
            self.setFollowersLabelAttributedText(departmentFullName: departmentFullName, universityName: universityName,facultyFullName: facultyFullName)
        }
        followers.translatesAutoresizingMaskIntoConstraints = false
        
        followers.topAnchor.constraint(equalTo: subjectsLabel.topAnchor).isActive = true
        followers.leftAnchor.constraint(equalTo: subjectsLabel.rightAnchor, constant: 10).isActive = true
        followers.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        followers.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setFollowersLabelAttributedText(departmentFullName: String, universityName: String,facultyFullName: String){
        var message: String = ""
        var textColor = UIColor()
        
        if NetworkReachabilityManager()!.isReachable{
            NetworkManager.shared.listenFollowers(universityName: universityName, facultyFullName: facultyFullName, departmentFullName: departmentFullName, completion: { (followersNumber) in
                message = String(followersNumber)
                
                if followersNumber != 0{
                    textColor = .black
                }else{
                    textColor = .red
                }
                
                let atributedString =  NSMutableAttributedString(string: "Подписчиков: "+"\(message)")
                
                let firstAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black,
                    .backgroundColor: self.view.backgroundColor!]
                let secondAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: textColor,
                    .backgroundColor: self.view.backgroundColor!]
                atributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 13))
                atributedString.addAttributes(secondAttributes, range: NSRange(location: 13, length: self.countDigits(number: followersNumber)))
                
                self.followers.attributedText = atributedString
            })
        }else{
            self.followers.text = "Подписчиков: Нет соединения"
        }
    }
    
    func countDigits(number: Int) -> Int{
        var count = 0
        var tempNumber = number
        while (tempNumber != 0) {
            tempNumber = tempNumber / 10;
            count += 1;
        }
        return count;
    }

    override func awakeFromNib() {
    }
    
}
