//
//  WishlistTableView.swift
//  Uni
//
//  Created by David Sarkisyan on 03.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit
import Alamofire

final class WishlistTableView: UIViewController {
    var tableView = UITableView()
    
    let warninglabel = UILabel()
    
    var t_count:Int = 0   // назначение tag ячейки
    var lastCell: DropdownCell = DropdownCell() // открытая ячейка (если нет, то nil)
    var button_tag:Int = -1  // tag открытой ячейки, если такая есть (иначе -1)
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Manager.shared.realm.objects(RealmObject.self).filter("minPoints != -1").count == 0{
            Manager.shared.warningLabel(label: warninglabel, warning: "Список пуст", viewController: self, tableView: tableView)
        }
        else{
            warninglabel.alpha = 0
            tableView.backgroundColor = .white
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        Manager.shared.workItem = DispatchWorkItem(qos: .userInteractive, flags: .barrier, block: {
            self.deleteMechanic(choosedRow: self.button_tag)
            self.tableView.reloadData()
        })
        Manager.shared.workItem.notify(queue: .main) {
        }
        
        Manager.shared.notificationCenter.addObserver(forName: NSNotification.Name(rawValue: "Department Deleted from Departments"), object: .none, queue: .main) { (Notification) in
            let objectToDelete = Notification.userInfo?["deletedObject"] as? Department
            let allObjects = Manager.shared.realm.objects(RealmObject.self).filter("minPoints != -1")
            
            let row = allObjects.firstIndex { (realmObject) -> Bool in
                return realmObject.departmentFullName == objectToDelete?.fullName
            }
            
            if (self.tableView.cellForRow(at: IndexPath(row: row!, section: 0)) as? DropdownCell) != nil{
            self.deleteMechanic(choosedRow: row!)
            }
            
            Manager.shared.deleteFromWishlist(sender: nil, setImage: nil, departmentFullName: objectToDelete!.fullName)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Manager.shared.realm.objects(RealmObject.self).filter("minPoints != -1").count != 0 {
            self.tableView.separatorColor = .white
        }
        Manager.shared.notificationCenter.post(Notification(name: Notification.Name(rawValue: "Internet Connection Status Changed")))
        
        lastCell = DropdownCell()
        button_tag = -1
        t_count = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.beginUpdates()
                        
               if lastCell.cellExists {
                   self.lastCell.animate(duration: 0.2, c: {
                       self.view.layoutIfNeeded()
                   })
        }
        self.tableView.endUpdates()
    }

}

extension WishlistTableView : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Manager.shared.realm.objects(RealmObject.self).filter("minPoints != -1").count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == button_tag {
            return 290
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if !lastCell.cellExists{
            return true
        }else { return false }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objects = Manager.shared.realm.objects(RealmObject.self).filter("minPoints != -1")
        let object = Array(objects)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: IndexPath(row: indexPath.row, section: 0)) as! DropdownCell
        if !cell.cellExists && (object.minPoints >= 0) {
            cell.setWishlistCell(universityName: object.universityName, departmentFullName: object.departmentFullName, facultyFullName: object.facultyFullName , subjects: Array(object.subjects), minPoints: object.minPoints, cell: cell)
            cell.open.tag = t_count
            cell.open.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
            cell.cellExists = true
        }
        t_count += 1
        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                var objectToDelete: RealmObject = RealmObject()
                do {
                    try Manager.shared.realm.write {
                      objectToDelete = Manager.shared.realm.objects(RealmObject.self).filter("departmentFullName = '\(((tableView.cellForRow(at: indexPath) as? DropdownCell)?.departmentNameLabel.text)!)'")[0]
                    }
                } catch{
                    print(error.localizedDescription)
                }
                deleteMechanic(choosedRow: indexPath.row)
                Manager.shared.deleteFromWishlist(sender: nil, setImage: nil, departmentFullName: objectToDelete.departmentFullName)
                Manager.shared.notificationCenter.post(Notification(name: Notification.Name(rawValue: "Department Deleted from wishlist")))
                tableView.reloadData()
            }
    }
    
    @objc func cellOpened(sender:UIButton) {
        self.tableView.beginUpdates()
        
        let previousCellTag = button_tag
        
        if lastCell.cellExists {
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
            
            if sender.tag == button_tag {
                button_tag = -1
                lastCell = DropdownCell()
            }
        }
        
        if sender.tag != previousCellTag {
            button_tag = sender.tag
            lastCell = tableView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! DropdownCell
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
            
        }
        
        self.tableView.endUpdates()
    }
    
    func deleteMechanic(choosedRow: Int) {
        if lastCell.cellExists{
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
            for cell in (self.tableView.visibleCells as! [DropdownCell]) {
                if cell.open.tag > choosedRow{
                    cell.open.tag -= 1
                }
            }
            (self.tableView.cellForRow(at: IndexPath(row: self.button_tag, section: 0)) as! DropdownCell).cellExists = false
            self.tableView.deleteRows(at: [IndexPath(row: self.button_tag, section: 0)], with: .left)
        }else{
            for cell in (self.tableView.visibleCells as! [DropdownCell]) {
                cell.cellExists = false
                if cell.open.tag > choosedRow{
                    cell.open.tag -= 1
                }
            }
//            (self.tableView.cellForRow(at: IndexPath(row: choosedRow, section: 0)) as! DropdownCell).cellExists = false
        }
        
        if Manager.shared.realm.objects(RealmObject.self).count == 0 {
            Manager.shared.warningLabel(label: self.warninglabel, warning: "Список пуст", viewController: self, tableView: self.tableView)
        }
        
        self.lastCell = DropdownCell()
        self.button_tag = -1
        self.t_count = 0
    }
    
    func  setTable(){
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.register(UINib(nibName: "DropdownCell", bundle: nil), forCellReuseIdentifier: "DropdownCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.dataSource = self
        tableView.delegate = self
    }
}


