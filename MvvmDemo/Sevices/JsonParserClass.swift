//
//  JsonParserClass.swift
//  MvvmDemo
//
//  Created by Point409 on 13/08/19.
//  Copyright © 2019 www.test.com. All rights reserved.
//

import Foundation
class JsonParserClass {
    static func parseJson(filename fileName: String,callback: @escaping (_ genres:[Swifter]?) -> ()) {
        DispatchQueue.global(qos:.background).async {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode([Swifter].self, from: data)
                    callback(jsonData)
                } catch {
                    callback(nil)
                    print("error:\(error)")
                }
            } else {
                callback(nil)
                print("**********Something Wrong **************")
            }
        }
    }
}
