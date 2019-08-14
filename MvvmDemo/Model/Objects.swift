//
//  Objects.swift
//  MvvmDemo
//
//  Created by Point409 on 13/08/19.
//  Copyright © 2019 www.test.com. All rights reserved.
//

import Foundation
import CoreLocation

struct Swifter: Decodable {
    var code: String?
    //var lat: CLLocationDegrees
    //var lon: CLLocationDegrees
    var lat: String?
    var lon: String?
    var name: String?
    var city: String?
    var state: String?
    var country:String?
    var woeid: String?
    var tz: String?
    var phone: String?
    var type:String?
    var email:String?
    var url:String?
    var runway_length:String?
    var elev:String?
    var icao:String?
    var direct_flights:String?
    var carriers:String?
    
    var location: CLLocation {
        let lat = Double(self.lat!)!
        let lon = Double(self.lon!)!
        return CLLocation(latitude:lat, longitude: lon)
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}
