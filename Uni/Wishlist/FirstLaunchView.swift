//
//  FirstLaunchView.swift
//  Uni
//
//  Created by David Sarkisyan on 07.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit
import paper_onboarding
import CircleMenu
import Firebase

final class FirstLaunchView: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var onboardingView: OnboardingView!
    
    let circleButton = CircleMenu(
           frame: CGRect(origin:  CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)),
           normalIcon:"icon_menu",
           selectedIcon:"icon_close",
           buttonsCount: 3,
           duration: 1,
           distance: 150)
    
    
    @IBAction func getStartedButtonAction(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "Onboarding Complete")
        userDefaults.synchronize()
    }
    
     override func viewDidLoad() {
            super.viewDidLoad()

            onboardingView.dataSource = self
            onboardingView.delegate = self
        }
    
}


extension FirstLaunchView: CircleMenuDelegate{
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        if atIndex == 0{
            button.backgroundColor = .black
            button.setImage(UIImage(systemName: "book"), for: .normal)
        }else if atIndex == 1{
            button.backgroundColor = .white
            button.setTitle("f(x)", for: .normal)
            button.setTitleColor(.black, for: .normal)
        }else if atIndex == 2{
            button.backgroundColor = UIColor(red: 106/256, green: 166/256, blue: 211/256, alpha: 1)
            button.setTitle("Bio", for: .normal)
            button.setTitleColor(.darkGray, for: .normal)
        }
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        circleMenu.backgroundColor = button.backgroundColor
        let userDefaults = UserDefaults.standard
        if atIndex == 0{
            userDefaults.set("Гуманитарные науки", forKey: "Увлечение")
            circleButton.setTitle(nil, for: .normal)
            circleButton.setImage(button.image(for: .selected), for: .normal)
        }else if atIndex == 1{
            circleButton.setImage(nil, for: .normal)
            circleButton.setTitleColor(.black, for: .normal)
            circleButton.setTitle(button.titleLabel!.text, for: .normal)
            userDefaults.set("Технические науки", forKey: "Увлечение")
        }else if atIndex == 2{
            circleButton.setImage(nil, for: .normal)
            circleButton.setTitleColor(.darkGray, for: .normal)
            circleButton.setTitle(button.titleLabel!.text, for: .normal)
            userDefaults.set("Естественные науки", forKey: "Увлечение")
        }
        circleButton.backgroundColor = button.backgroundColor
        UIView.animate(withDuration: 0.5) {
            self.getStartedButton.alpha = 1
        }
        self.view.reloadInputViews()
        userDefaults.synchronize()
    }
    
    func setupCircleButton(){
        self.view.addSubview(circleButton)

        circleButton.backgroundColor = .midnightBlue
        circleButton.delegate = self
        
        circleButton.translatesAutoresizingMaskIntoConstraints = false
        
        circleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circleButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        circleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 230).isActive = true
        circleButton.heightAnchor.constraint(equalTo: circleButton.widthAnchor).isActive = true
        
        circleButton.layer.cornerRadius = 70 / 2
        
        UIView.animate(withDuration: 0.3) {
            self.circleButton.alpha = 1
        }
    }
}



extension FirstLaunchView: PaperOnboardingDataSource, PaperOnboardingDelegate{
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let backgroundColourOne = UIColor(red: 217/256, green: 72/256, blue: 89/256, alpha: 1)
        let backgroundColourTwo = UIColor(red: 106/256, green: 166/256, blue: 211/256, alpha: 1)
        let backgroundColourThree = UIColor(red: 168/256, green: 200/256, blue: 78/256, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        
        let transparentImage =  UIImageView(image: UIImage(named: "Transparent.jpg"))
        
        UIGraphicsEndImageContext()
//        let secondImage = setupSecondImage()
        let thirdImage = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
        thirdImage?.withTintColor(.black)
//        let fourthImage = UIImage(named: "Add to wishlist Example")!
        
        
        return[OnboardingItemInfo(informationImage: UIImage(named: "FirstLaunch Image1")!, title: "Выбирайте университет по личным предпочтениям", description: "", pageIcon: transparentImage.image!, color: backgroundColourOne, titleColor: UIColor.black, descriptionColor: UIColor.black, titleFont: titleFont, descriptionFont: descriptionFont),
               OnboardingItemInfo(informationImage: UIImage(systemName: "map.fill")!, title: "Рассчитывайте время маршрута до выбранного университета", description: "", pageIcon: transparentImage.image!, color: backgroundColourTwo, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
               OnboardingItemInfo(informationImage: thirdImage!, title: "Добавляйте понравившиеся кафедры в избранное и просматривайте их offline", description: "", pageIcon: transparentImage.image!, color: backgroundColourThree, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
               OnboardingItemInfo(informationImage: transparentImage.image!, title: "Выберите свои интересы", description: "черная - гуманитарные науки \n белая - технические науки \n голубая - естественные науки", pageIcon: transparentImage.image!, color: #colorLiteral(red: 0.9334822297, green: 0.9955082536, blue: 0.9193486571, alpha: 1), titleColor: UIColor.black, descriptionColor: UIColor.black, titleFont: titleFont, descriptionFont: descriptionFont)
            ][index]
    }
    
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
        
    }
    
    func onboardinPageItemRadius() -> CGFloat {
        return CGFloat(integerLiteral: 5)
    }
    
    func onboardingPageItemSelectedRadius() -> CGFloat {
        return CGFloat(integerLiteral: 10)
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index != 3{
            if UserDefaults.standard.string(forKey: "Увлечение") == nil{
                if self.getStartedButton.alpha == 1{
                    UIView.animate(withDuration: 0.4) {
                        self.getStartedButton.alpha = 0
                    }
                }
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3{
           setupCircleButton()
        }else{
            circleButton.hideButtons(0.25)
            UIView.animate(withDuration: 0.1) {
                      self.circleButton.alpha = 0
                  }
        }
}
    
}

