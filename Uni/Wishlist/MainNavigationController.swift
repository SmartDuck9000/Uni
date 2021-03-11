//
//  MainNavigationController.swift
//  Uni
//
//  Created by David Sarkisyan on 09.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

final class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let userFefaults = UserDefaults.standard
          if userFefaults.bool(forKey: "Onboarding Complete"){
            perform(#selector(showTutorial), with: nil, afterDelay: 0.01)
          } else{
            perform(#selector(showApp), with: nil, afterDelay: 0.01)
        }
    }
    
    @objc func showTutorial(){
        let viewController = TableViewUniversities()
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func showApp(){
        let viewController = FirstLaunchView()
        present(viewController, animated: true, completion: nil)
    }
}
