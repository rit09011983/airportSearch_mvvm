//
//  GeneralFuns.swift
//  MvvmDemo
//
//  Created by Point409 on 13/08/19.
//  Copyright © 2019 www.test.com. All rights reserved.
//

import Foundation
import UIKit

class GeneralFuns {
    static let shared = GeneralFuns()
    
    init(){}
    
    func alertMessage(title:String,message:String, context:UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  {(action:UIAlertAction!) in
            
        }))
        context.present(alert, animated: false)
    }
}
