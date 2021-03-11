//
//  LaunchView.swift
//  Uni
//
//  Created by David Sarkisyan on 12.01.2020.
//  Copyright © 2020 DavidS & that's all. All rights reserved.
//

import UIKit

class LaunchView: UIViewController {
    
    var logoLabel = UILabel()
    var logoImage = UIImageView()
    
    private let superButton = UIButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        // animation
        setupLogoLabel()
        
        let scaleDuration: TimeInterval = 2
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: scaleDuration, animations: {
                self.logoLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { (_) in
                    sleep(1)
                    let modalViewController = self.nextViewController()
                    modalViewController.modalPresentationStyle = .fullScreen
                    self.present(modalViewController, animated: true, completion: nil)
                })
            }
        
    }
    
    
    func setupLogoLabel(){
        view.addSubview(logoLabel)
        
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        logoLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        logoLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        logoLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        logoLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    
        logoLabel.textAlignment = .center
        logoLabel.font = UIFont(name: "Georgia" , size: 45 )
        logoLabel.text = "Uni"
        logoLabel.textColor = .white
        logoImage.image = UIImage(named: "AppIcon")
    }
    
    func nextViewController() -> UIViewController{
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var initialVC = sb.instantiateViewController(identifier: "Onboarding")
        let userDefaults = UserDefaults.standard
        if  userDefaults.bool(forKey: "Onboarding Complete"){
            initialVC = sb.instantiateViewController(identifier: "TabBarController")
        }
        return initialVC
    }
}


