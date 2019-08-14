//
//  AirportDetailsController.swift
//  MvvmDemo
//
//  Created by Point409 on 13/08/19.
//  Copyright © 2019 www.test.com. All rights reserved.
//

import UIKit
import CoreLocation

class AirportDetailsController:UIViewController,UITableViewDelegate, UITableViewDataSource, AirportDetailsViewModelDelegate {
    
    @IBOutlet weak var airportTableView:UITableView!
    var noFoundRecords = false
    var _airportDetailsViewModel: AirportDetailsViewModel?
    let global = UIApplication.shared.delegate as! AppDelegate
    
    var lon:Double?
    var lat:Double?
    var city:String?
    
    var swifter = [Swifter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        airportTableView.tableFooterView = UIView(frame: .zero)
        
        _airportDetailsViewModel = AirportDetailsViewModel()
        _airportDetailsViewModel?.delegate = self
        _airportDetailsViewModel?.swifter = swifter
        
        global.showActivityIndicator(view, Constants.PLEASE_WAIT)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTop5NearestAirportList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title =  self.city != nil ? "Top 5 Nearest Airport Around \(self.city!)" :"Top 5 Nearest Airport"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func refreshScreen(status:Bool) {
        global.stopActivityIndicator()
        if status {
            // Success
            self.airportTableView.reloadData()
        } else {
            //error
            GeneralFuns.shared.alertMessage(title: Constants.SORRY, message:  Constants.NO_INFORMATION_FOUND, context: self)
        }
    }
    
    private func getTop5NearestAirportList() {
        if self.lat != nil && self.lon != nil {
            let myLoc = CLLocation(latitude:self.lat! , longitude:self.lon!)
            _airportDetailsViewModel!.getTop5NearestAirport(loc:myLoc)
        } else {
            print("**********Please check Latitude and longitude!!!****************")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let airportCount =  _airportDetailsViewModel?.numberOfItemInSection(section: section) ?? 0
        if airportCount == 0 && noFoundRecords == true {
            self.airportTableView.setEmptyMessage(Constants.NO_RECORD_FOUND)
        } else {
            self.airportTableView.restore()
        }
        return airportCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text =  _airportDetailsViewModel!.titleForItemAtIndexPath(indexPath: indexPath as NSIndexPath)
        cell.detailTextLabel?.text = _airportDetailsViewModel!.titleDescriptionForItemAtIndexPath(indexPath: indexPath as NSIndexPath)
        
        return cell
    }
}




