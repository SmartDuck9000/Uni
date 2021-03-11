//
//  DepartmentsTableView.swift
//  Uni
//
//  Created by David Sarkisyan on 13/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit
import Firebase

final class DepartmentsTableView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var animator = UIDynamicAnimator() // Открытие Сортировки
    
    let sortTableView = SortTableView()
    let sortHeader = UILabel()
    
    let openSortButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Loader.shared.showActivityIndicatory(uiView: tableView, blurView: Loader.shared.blurView, loadingView: Loader.shared.loadingView , actInd: Loader.shared.actInd)
        Manager.shared.notificationCenter.addObserver(forName: NSNotification.Name(rawValue: "Department Deleted from wishlist"), object: .none, queue: .main) { (Notification) in
            self.tableView.reloadData()
        }
        
        Manager.shared.notificationCenter.addObserver(forName: NSNotification.Name(rawValue: "Sort Selected"), object: .none, queue: .main) { (Notification) in
            self.openSortButtonAction()
            Manager.shared.sort(type: Notification.userInfo!["type"] as! Int, tableView: self.tableView)
        }
        
        NetworkManager.shared.loadDepartments(subjects: Manager.shared.filterSettings.subjects ,minPoints: Manager.shared.filterSettings.minPoint, completion: { [weak self] in
            DispatchQueue.main.async{
                Loader.shared.removeActivityIndicator(blurView: Loader.shared.blurView, loadingView: Loader.shared.loadingView, actInd: Loader.shared.actInd)
                self?.tableView.reloadData()
            }
        })
        
        setupTable()
        setupOpenSortButton()
    }
    
    func setupOpenSortButton(){
          navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сортировать", style: .plain, target: self, action: #selector(openSortButtonAction))
          navigationItem.rightBarButtonItem?.tintColor = .white
      }

    @objc func openSortButtonAction(){
        setupBlurView()
        if !view.subviews.contains(sortTableView){
            setupSortTableView()
            openSortTableAnimation()
            UIView.animate(withDuration: 1) {
                self.tableView.addSubview(Loader.shared.blurView)
            }
        }else{
            sortTableView.reloadData()  // СПРОСИТЬ ПОЧЕМУ НАДО ТАК ПИСАТЬ, А ИНАЧЕ ОБНОВЛЯЕТСЯ САМА ПО СЕБЕ ЕТОЛЬКО ПОСЛЕДНЯЯ СТРЧОКА
            UIView.animate(withDuration: 10) {
                Loader.shared.removeActivityIndicator(blurView: Loader.shared.blurView, loadingView: Loader.shared.loadingView, actInd: Loader.shared.actInd)
                self.sortHeader.removeFromSuperview()
                self.sortTableView.removeFromSuperview()
            }
        }
      }
    
    
    func openSortTableAnimation(){
        animator = UIDynamicAnimator(referenceView: view)
        
        let gravity = UIGravityBehavior(items: [sortTableView])
        let collision = UICollisionBehavior(items: [sortTableView])
        
        collision.addBoundary(withIdentifier: "Sort Table Bottom" as NSCopying,
                              from: CGPoint(x: 0, y: sortTableView.frame.height + 60 + view.safeAreaInsets.top ), // 60 - высота header'а
                              to: CGPoint(x: view.frame.width, y: sortTableView.frame.height + 60 + view.safeAreaInsets.top))
        
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
    }
    
    func setupBlurView(){
        Loader.shared.blurView.frame = view.bounds
    }
      
    func setupSortTableView(){
        
        view.addSubview(sortHeader)
        
        sortHeader.alpha = 0
        
        sortHeader.translatesAutoresizingMaskIntoConstraints = false
        
        sortHeader.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sortHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        sortHeader.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sortHeader.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        sortHeader.backgroundColor = UIColor(red: 28/256, green: 28/256, blue: 30/256, alpha: 1)
        sortHeader.textColor = .white
        sortHeader.text = "Выберите тип сортировки"
        sortHeader.font = UIFont(name: "AvenirNext-Regular", size: 18)!
        sortHeader.textAlignment = .center
        
        UIView.animate(withDuration: 1.5) {
            self.sortHeader.alpha = 1
        }
        
        view.addSubview(sortTableView)
        
        sortTableView.frame = CGRect(x: 0, y: -200, width: view.frame.width , height: CGFloat(Sort.Occasions.allCases.count) * 60)
    }
    
    func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        
        self.title = "Кафедры"
        
        sortTableView.delegate = sortTableView
        sortTableView.dataSource = sortTableView
        
        tableView.frame = view.bounds
        
        tableView.separatorColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView.init(frame: .zero)
    }
    
}

extension DepartmentsTableView : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Manager.shared.UFD[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as? Faculty]!?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let department = (Manager.shared.UFD[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as? Faculty]!)![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentCell") as! DepartmentCell
        cell.setDepartmentCell(department: department)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backgroundView = UIView()
        let label = UILabel()
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        
        label.frame = CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 80)
        label.layer.masksToBounds = true
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor(red: 28/256, green: 28/256, blue: 30/256, alpha: 1)
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)!
        
        label.text = "\((Manager.shared.choosed[1] as! Faculty).fullName)"

        label.layer.cornerRadius = 10
        
        backgroundView.addSubview(label)

        return backgroundView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let department = Manager.shared.UFD[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as? Faculty]!![indexPath.row]
        
        var alert = UIAlertController()
        var name = department?.fullName
        
        if (department?.name) != ""{
            name = department?.name
        }
        if department?.link != "" {
            alert = UIAlertController(title: "", message: "Перейти на сайт кафедры \(name!)?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (alert: UIAlertAction) -> Void in
                if let url = URL(string: "\(department!.link)") {
                    UIApplication.shared.open(url)
                }
            }))
            alert.addAction(UIAlertAction(title: "Отменить", style: .default, handler: nil))
        }else{
            alert = UIAlertController(title: "", message: "Сайт данной кафедры в данный момент недоступен", preferredStyle: .alert)
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

