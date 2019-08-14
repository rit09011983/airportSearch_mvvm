//
//  AirportDetailsViewModel.swift
//  MvvmDemo
//
//  Created by Point409 on 13/08/19.
//  Copyright © 2019 www.test.com. All rights reserved.
//

import Foundation
import CoreLocation

protocol AirportDetailsViewModelDelegate: class {
    func refreshScreen(status:Bool)
}

class AirportDetailsViewModel {
    var swifter = [Swifter]()
    weak var delegate: AirportDetailsViewModelDelegate?
    var didCompleteTopAirportSortedArray = false
    init() {
        
    }
    
    func numberOfItemInSection(section:Int)->Int{
        if didCompleteTopAirportSortedArray == true {
            if self.swifter.count > 5 {
                return 5
            } else {
                return self.swifter.count
            }
        } else {
            return 0
        }
    }
    
    func titleForItemAtIndexPath(indexPath: NSIndexPath)-> String {
        return "\(String(describing: self.swifter[indexPath.row].name!)) , \(String(describing: self.swifter[indexPath.row].country!)) "
    }
    
    func titleDescriptionForItemAtIndexPath(indexPath: NSIndexPath)-> String {
        if self.swifter[indexPath.row].runway_length != nil && self.swifter[indexPath.row].runway_length!.count > 0 {
            return "Runway Length : \(String(describing: self.swifter[indexPath.row].runway_length!))"
        } else {
            return "Runway Length : NOT AVAILABLE"
        }
    }
    
    // Getting top 5 airport list on the basis of lat and lon
    func getTop5NearestAirport(loc:CLLocation) {
        swifter.sort(by:loc)
        didCompleteTopAirportSortedArray = true
        if swifter.count > 0 {
            delegate?.refreshScreen(status:true)
        } else {
            delegate?.refreshScreen(status:false)
        }
    }
}
