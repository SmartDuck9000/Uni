//
//  TabBarController.swift
//  Uni
//
//  Created by David Sarkisyan on 04.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar(){
       tabBar.isTranslucent = true
        tabBar.tintColor = .white
    }
    
}
