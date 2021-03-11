//
//  Loader.swift
//  Uni
//
//  Created by David Sarkisyan on 26.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import  UIKit

class Loader {
    
    private init(){}
    
    static var shared = Loader()
    
    let actInd = UIActivityIndicatorView()
    let loadingView: UIView = UIView()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
     func showActivityIndicatory(uiView: UIView, blurView: UIVisualEffectView, loadingView: UIView, actInd: UIActivityIndicatorView) {
            blurView.frame = uiView.frame

    //        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    //        loadingView.center = uiView.center
    //        loadingView.backgroundColor = UIColor.black
    //        loadingView.clipsToBounds = true
    //        loadingView.layer.cornerRadius = 10

            actInd.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
            actInd.center = uiView.center
            actInd.color = .white
            actInd.style = UIActivityIndicatorView.Style.large
    //        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
            actInd.color = .black
            
            uiView.addSubview(blurView)
            uiView.addSubview(actInd)
    //        loadingView.addSubview(actInd)
            
            actInd.startAnimating()
        }
        
        func removeActivityIndicator(blurView: UIVisualEffectView, loadingView: UIView, actInd: UIActivityIndicatorView){

            actInd.stopAnimating()

            actInd.removeFromSuperview()
            loadingView.removeFromSuperview()
            blurView.removeFromSuperview()
        }
    
}
