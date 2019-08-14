//
//  Callapi.swift
//  MvvmDemo
//
//  Created by Point409 on 13/08/19.
//  Copyright © 2019 www.test.com. All rights reserved.
//

import Foundation
import UIKit

class Callapi{
    
    static func getApiGenericCall(requestPath:String,httpMethod:String,callback:@escaping (_ genres:[Swifter]?) -> ()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let request = NSMutableURLRequest(url: NSURL(string: requestPath)! as URL)
        request.httpMethod = httpMethod
        
        print("Api url = \(requestPath)")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            print(response as? HTTPURLResponse as Any)
            
            if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode([Swifter].self, from: data!)
                    print(jsonData)
                    callback(jsonData)
                } catch {
                    callback(nil)
                    print("error:\(String(describing: error))")
                }
            } else {
                callback(nil)
                print("error:\(String(describing: error))")
            }
        })
        task.resume()
    }
}


