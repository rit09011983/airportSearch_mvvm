//
//  AirportListViewModel.swift
//  MvvmDemo
//
//  Created by Point409 on 13/08/19.
//  Copyright © 2019 www.test.com. All rights reserved.
//

import Foundation

protocol AirportListViewModelDelegate: class {
    func homeInfo(message:String?, status:Bool)
}

class AirportListViewModel {
    
    weak var delegate: AirportListViewModelDelegate?
    let isRemoteCall = true
    
    var cityInfo = [Swifter]()
    var cityInfoFilter:[Swifter] = []
    var preservePrviousSearch:[Swifter] = []
    
    var isSearch = false
    var restrictReloadedFilter = 1
    
    let queue = OperationQueue()
    
    init() {
        
    }
    
    func numberOfItemInSection(section:Int)->Int{
        if  self.isSearch && self.restrictReloadedFilter == 1 {
            return self.cityInfoFilter.count
        }
        
        return self.cityInfo.count
    }
    
    
    func titleForItemAtIndexPath(indexPath: NSIndexPath)-> String {
        if(self.isSearch && self.restrictReloadedFilter == 1) {
            if self.cityInfoFilter.count > 0 {
                return "\(String(describing: cityInfoFilter[indexPath.row].city!))"
            }
        }
        
        return "\(String(describing: cityInfo[indexPath.row].city!))"
        
    }
    
    func titleDescriptionForItemAtIndexPath(indexPath: NSIndexPath)-> String {
        if(self.isSearch && self.restrictReloadedFilter == 1){
            if self.cityInfoFilter.count > 0 {
                return "\(String(describing: cityInfoFilter[indexPath.row].country!))"
            }
        }
        
        return "\(String(describing: cityInfo[indexPath.row].country!))"
    }
    
    // Search by Airport Cities
    func searchAirportByCities (searchString:String) {
        if self.cityInfoFilter.count == 0 && self.preservePrviousSearch.count == 0{
            let filterAirportCities = self.cityInfo.filter({$0.city!.hasPrefixCheck(prefix: searchString, isCaseSensitive: false)})
            self.cityInfoFilter = filterAirportCities.sorted(by:{ $0.city! < $1.city! })
            self.preservePrviousSearch = self.cityInfoFilter
        } else {
            let filterName = self.preservePrviousSearch.filter({$0.city!.hasPrefixCheck(prefix: searchString, isCaseSensitive: false)})
            self.cityInfoFilter = filterName.sorted(by:{ $0.city! < $1.city! })
        }
    }
    
    // Call AirportApi for all airport info in Json Format
    func callAirportApi() {
        if  isRemoteCall == true {
            
            Callapi.getApiGenericCall(requestPath: ApiConstants.airports,httpMethod:"GET", callback: {(response) in DispatchQueue.main.async {
                
                if response != nil {
                    self.cityInfo = response!.filter{$0.city! != ""}.sorted(by:{ $0.city! < $1.city! })
                    self.delegate?.homeInfo(message: nil, status: true)
                } else {
                    self.delegate?.homeInfo(message:Constants.SOMETHING_WRONG, status: false)
                }
                
                }})
        } else {
            
            JsonParserClass.parseJson(filename: "airports",callback: {(response) in
                DispatchQueue.main.sync {
                    if response != nil {
                        
                        self.cityInfo = response!.filter{$0.city! != ""}.sorted(by:{ $0.city! < $1.city! })
                        
                        self.delegate?.homeInfo(message: nil, status: true)
                    } else {
                        self.delegate?.homeInfo(message:Constants.SOMETHING_WRONG, status: false)
                    }
                }})
        }
    }
}

