//
//  NavigationController.swift
//  Uni
//
//  Created by David Sarkisyan on 04.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
