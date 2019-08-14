//
//  StringExtension.swift
//  MvvmDemo
//
//  Created by Point409 on 13/08/19.
//  Copyright © 2019 www.test.com. All rights reserved.
//

import Foundation
import UIKit

extension String {
    // Returns true if the String starts with a substring matching to the prefix-parameter.
    // If isCaseSensitive-parameter is true, the function returns false,
    // if you search "sA" from "San Antonio", but if the isCaseSensitive-parameter is false,
    // the function returns true, if you search "sA" from "San Antonio"
    
    func hasPrefixCheck(prefix: String, isCaseSensitive: Bool) -> Bool {
        
        if isCaseSensitive == true {
            return self.hasPrefix(prefix)
        } else {
            var thePrefix: String = prefix, theString: String = self
            
            while thePrefix.count != 0 {
                if theString.count == 0 { return false }
                if theString.lowercased().first != thePrefix.lowercased().first { return false }
                theString = String(theString.dropFirst())
                thePrefix = String(thePrefix.dropFirst())
            }; return true
        }
    }
}
