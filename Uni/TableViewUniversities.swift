//
//  TableViewController1ViewController.swift
//  Uni
//
//  Created by David Sarkisyan on 09/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit
import Firebase
import SkeletonView


class TableViewUniversities: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var warning = UILabel()
            
    private var filterSettings = Filter(country: nil, subjects: nil, minPoint: nil, military: nil, campus: nil)
    
    private let filterButton = UIButton()
    
    private let searchField = UISearchBar()
    private let searchTitle = UILabel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupFilterButton() {
        self.view.addSubview(filterButton)
        
        if let filterImage = UIImage(named: "filterIcon") {
            filterButton.setImage(filterImage, for: .normal)
        }
        
        filterButton.frame = CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: self.view.frame.height - 180), size: CGSize(width: 80, height: 80))
        filterButton.layer.cornerRadius = filterButton.frame.width / 2
        
        filterButton.layer.shadowColor = UIColor.black.cgColor
        filterButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        filterButton.layer.shadowOpacity = 1.0
        filterButton.layer.shadowRadius = filterButton.layer.cornerRadius * 1.5
        
        filterButton.backgroundColor = UIColor.black
        
        filterButton.addTarget(self, action: #selector(openFilter), for: .touchUpInside)
    }
    
    private func setupNavigationItem() {
        searchTitle.text = "Uni"
        searchTitle.textAlignment = .center
        searchTitle.textColor = .white
        searchTitle.font = UIFont(name: "Georgia", size: 24)
        
        navigationItem.titleView = searchTitle
    }
    
    private func setupSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchButton.tintColor = .white
        navigationItem.rightBarButtonItem = searchButton
    }
    
    private func setupEndSearchingButton() {
        let endSearchingButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(endSearching))
        endSearchingButton.tintColor = .clear
        endSearchingButton.isEnabled = false
        navigationItem.leftBarButtonItem = endSearchingButton
    }
    
    private func setupSearchField() {
        searchField.placeholder = "Введите университет"
        
        if let textField = searchField.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
        }
        
        searchField.delegate = self
        searchField.isHidden = false
    }
    
    private func reloadData() {
        if  Manager.shared.flagFilterChanged {
            Loader.shared.showActivityIndicatory(uiView: view, blurView: Loader.shared.blurView, loadingView: Loader.shared.loadingView, actInd: Loader.shared.actInd)
            
            NetworkManager.shared.loadUniversities(city: Manager.shared.filterSettings.country, subjects: Manager.shared.filterSettings.subjects , minPoints: Manager.shared.filterSettings.minPoint, dormitory: Manager.shared.filterSettings.campus, militaryDepartment: Manager.shared.filterSettings.military, completion: { (currentUniversity, allUniversitiesNumber) in
                DispatchQueue.main.async{
                    Manager.shared.dataUFD = Manager.shared.UFD
                    self.tableView.reloadData()
                    Loader.shared.removeActivityIndicator(blurView: Loader.shared.blurView, loadingView: Loader.shared.loadingView, actInd: Loader.shared.actInd)
                    if (Manager.shared.UFD.count == 0) && (currentUniversity == allUniversitiesNumber){
                        Manager.shared.warningCheck(occasion: "show", viewController: self, warningLabel: self.warning, tableView: self.tableView)
                    } else{ Manager.shared.warningCheck(occasion: "remove" , viewController: self, warningLabel: self.warning, tableView: self.tableView) }
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        filterButton.isHidden = false
        filterButton.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Manager.shared.internetConnectionCheck(viewcontroller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupSearchButton()
        setupEndSearchingButton()
        setupSearchField()
        
        setupFilterButton()
        
        reloadData()
        setupTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        filterButton.isHidden = true
        filterButton.isEnabled = false
    }
  
    func setupTable(){
        self.title = "Uni"
        
        self.tabBarController?.tabBar.items?[0].title = NSLocalizedString("Home", comment: "")
        tableView.clipsToBounds = true
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        tableView.separatorInset = .zero
    }
    
    @objc private func openFilter() {
        let filterController = FilterViewController()
        self.present(filterController, animated: true, completion: nil)
    }
    
    @objc private func search() {
        navigationItem.titleView = searchField
        
        navigationItem.rightBarButtonItem = nil
        
        navigationItem.leftBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc private func endSearching() {
        navigationItem.titleView = searchTitle
    
        setupSearchButton()
        
        navigationItem.leftBarButtonItem?.tintColor = .clear
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
}

extension TableViewUniversities :  SkeletonTableViewDataSource, SkeletonTableViewDelegate{
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "UniversityCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Manager.shared.UFD.keys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let university = Array(Manager.shared.UFD.keys)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityCell") as! UniversityCell
        cell.setupUniversityCell(university: university)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            Manager.shared.choosed[0] = Array(Manager.shared.UFD.keys)[indexPath.row]
            let viewController = storyboard?.instantiateViewController(identifier: "факультет") as! FacultiesTableView
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(viewController, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//
//        label.numberOfLines = 0
//        label.textAlignment = .left
//        label.textColor = .black
//        label.backgroundColor = view.backgroundColor
//
//        label.font = UIFont(name: "AvenirNext-Regular", size: 30)!
//        label.text = "Выберите университет"
//
//        return label
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 150
//    }
    
}

extension TableViewUniversities: UISearchBarDelegate {
    
    // called when text changes (including clear)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            Manager.shared.UFD = Manager.shared.dataUFD
        } else {
            Manager.shared.UFD = Manager.shared.dataUFD.filter {
                let fullName = $0.key.fullName.lowercased()
                let name = $0.key.name.lowercased()
                let text = searchText.lowercased()
                return fullName.contains(text) || name.contains(text)
            }
        }
        tableView.reloadData()
    }
}





//        db.collection("Universities").addDocument(data: ["name":"МГТУ","dormitory": true]).collection("МГТУfaculties").addDocument(data: ["name":"РК","minPoints": 150])
//        db.collection("Universities").document("6CvTvBl7wcwcMrUW1d6C").collection("МГТУfaculties").addDocument(data: ["name":"ИУ","minPoints": 98])
