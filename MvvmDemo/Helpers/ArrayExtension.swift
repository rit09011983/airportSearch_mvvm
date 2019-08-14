//
//  ArrayExtension.swift
//  MvvmDemo
//
//  Created by Point409 on 13/08/19.
//  Copyright © 2019 www.test.com. All rights reserved.
//

import Foundation
import CoreLocation

extension Array where Element == Swifter {
    
    mutating func sort(by location: CLLocation) {
        return sort(by: { $0.distance(to: location) < $1.distance(to: location) })
    }
    
    func sorted(by location: CLLocation) -> [Swifter] {
        return sorted(by: { $0.distance(to: location) < $1.distance(to: location) })
    }
}
