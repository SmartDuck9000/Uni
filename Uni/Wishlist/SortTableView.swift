//
//  SortTableView.swift
//  Uni
//
//  Created by David Sarkisyan on 14.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

class SortTableView: UITableView {

    let tableView = UITableView()
    
    var choosedSortType: Int?
 
    func setupTable(){
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
    }

}

extension SortTableView: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Sort.Occasions.allCases.count  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(SortCell.self, forCellReuseIdentifier: "SortCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell") as! SortCell
        cell.setCell(index: indexPath.row, choosedTypeIndex: choosedSortType)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Manager.shared.notificationCenter.post(name: Notification.Name(rawValue: "Sort Selected"), object: nil, userInfo: ["type" : indexPath.row])
        
        choosedSortType = indexPath.row
    }
    
}
