//
//  ActivityIndicator.swift
//  MvvmDemo
//
//  Created by Point409 on 13/08/19.
//  Copyright © 2019 www.test.com. All rights reserved.
//

import UIKit

class ActivityIndicator {
    
    let viewForActivityIndicator = UIView()
    var view: UIView
    
    let activityIndicatorView = UIActivityIndicatorView()
    var text = "LOADING"
    
    init(mView:UIView, mDisplayText:String) {
        view = mView
        text = mDisplayText
    }
    
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: CGRect(x:0,y:60,width: self.view.bounds.size.width,height: self.view.bounds.size.height))
        bdView.backgroundColor = UIColor.clear
        return bdView
    }()
    
    func showActivityIndicator() {
        
        //UIApplication.shared.beginIgnoringInteractionEvents()
        //
        //view.backgroundColor = .clear
        view.addSubview(backdropView)
        
        let loadingTextLabel = UILabel(frame: CGRect(x:0,y: 0,width: 250,height: 80))
        
        viewForActivityIndicator.frame = CGRect(x: 50, y: self.view.frame.size.height/2 - 150, width: self.view.frame.size.width-100, height:150)
        
        viewForActivityIndicator.backgroundColor =  UIColor(42.0, 53.0, 67.0, 0.9)
        viewForActivityIndicator.alpha = 0.9
        viewForActivityIndicator.layer.cornerRadius = 10.0
        
        view.addSubview(viewForActivityIndicator)
        
        activityIndicatorView.center = CGPoint(x: viewForActivityIndicator.bounds.size.width/2, y: viewForActivityIndicator.bounds.size.height/2 - 30)
        
        loadingTextLabel.textColor = UIColor.white
        loadingTextLabel.text = text
        loadingTextLabel.textAlignment = .center
        loadingTextLabel.numberOfLines = 4
        
        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 50)
        viewForActivityIndicator.addSubview(loadingTextLabel)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .whiteLarge
        viewForActivityIndicator.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        
    }
    
    func stopActivityIndicator() {
        backdropView.removeFromSuperview()
        viewForActivityIndicator.removeFromSuperview()
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
}
