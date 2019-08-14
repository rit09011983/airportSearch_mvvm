//
//  AirportListController.swift
//  MvvmDemo
//
//  Created by Point409 on 13/08/19.
//  Copyright © 2019 www.test.com. All rights reserved.
//

import Foundation
import UIKit

class AirportListController:UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate,AirportListViewModelDelegate {
    
    @IBOutlet weak var airportTableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    let global = UIApplication.shared.delegate as! AppDelegate
    
    var _airportListViewModel: AirportListViewModel?
    
    var noFoundRecords = false
    
    fileprivate var collapseDetailViewController = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        airportTableView.tableFooterView = UIView(frame: .zero)
        
        _airportListViewModel = AirportListViewModel()
        _airportListViewModel?.delegate = self
        _airportListViewModel?.queue.maxConcurrentOperationCount = 1
        
        splitViewController?.delegate = self
        
        self.airportTableView.tableFooterView = UIView(frame: .zero)
        
        self.searchBar.delegate = self
        
        self.searchBar.accessibilityIdentifier = "searchBar"
        
        self.airportTableView.accessibilityIdentifier = "citiesTable"
        
        getAirportList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func homeInfo(message: String?, status: Bool) {
        global.stopActivityIndicator()
        
        if status {
            // Success
            noFoundRecords = false
        } else {
            //error
            if let lMessage = message {
                GeneralFuns.shared.alertMessage(title: Constants.SORRY, message:  lMessage, context: self)
                noFoundRecords = true
            }
        }
        self.airportTableView.reloadData()
    }
    
    private func getAirportList() {
        if IfInternet.connected() {
            global.showActivityIndicator(view, Constants.PROCESSING_REQUEST)
            _airportListViewModel!.callAirportApi()
        } else {
            GeneralFuns.shared.alertMessage(title: Constants.SORRY, message:  Constants.NO_INTERNET, context: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let airportCount =  _airportListViewModel?.numberOfItemInSection(section: section) ?? 0
        
        if airportCount == 0 && noFoundRecords == true {
            self.airportTableView.setEmptyMessage(Constants.NO_RECORD_FOUND)
        } else {
            self.airportTableView.restore()
        }
        
        return airportCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for:indexPath)
        configureCell(cell: cell, forRowAtIndexPath: indexPath as NSIndexPath)
        cell.accessibilityIdentifier = "myCellId_\(indexPath.row)"
        if indexPath.row%2 == 0 {
            cell.backgroundColor =  UIColor(red:239.0/255.0, green:233.0/255.0, blue:244.0/255.0,alpha:0.9)
        } else {
            cell.backgroundColor =  UIColor(red:170.0/255.0, green:170.0/255.0, blue:170.0/255.0,alpha:0.9)
        }
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        cell.backgroundColor = .clear
        cell.textLabel?.text =  _airportListViewModel!.titleForItemAtIndexPath(indexPath: forRowAtIndexPath as NSIndexPath)
        cell.detailTextLabel?.text = _airportListViewModel!.titleDescriptionForItemAtIndexPath(indexPath: forRowAtIndexPath as NSIndexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = airportTableView.indexPathForSelectedRow {
                var woeid = "0"
                let controller = (segue.destination as! UINavigationController).topViewController as! AirportDetailsController
                print(_airportListViewModel!.isSearch)
                if(_airportListViewModel!.isSearch) {
                    controller.lon = 0.0
                    controller.lat = 0.0
                    if let lon = _airportListViewModel!.cityInfoFilter[indexPath.row].lon {
                        controller.lon = Double(lon)!
                    }
                    
                    if let lat = _airportListViewModel!.cityInfoFilter[indexPath.row].lat {
                        controller.lat = Double(lat)!
                    }
                    
                    if let city = _airportListViewModel!.cityInfoFilter[indexPath.row].city {
                        controller.city = city
                    }
                    
                    if let _woeid = _airportListViewModel!.cityInfoFilter[indexPath.row].woeid {
                        woeid = _woeid
                    }
                    
                } else {
                    
                    controller.lon = 0.0
                    controller.lat = 0.0
                    
                    if let lon = _airportListViewModel!.cityInfo[indexPath.row].lon {
                        controller.lon = Double(lon)!
                    }
                    
                    if let lat = _airportListViewModel!.cityInfo[indexPath.row].lat {
                        controller.lat = Double(lat)!
                    }
                    
                    if let city = _airportListViewModel!.cityInfo[indexPath.row].city {
                        controller.city = city
                    }
                    
                    if let _woeid = _airportListViewModel!.cityInfo[indexPath.row].woeid {
                        woeid = _woeid
                    }
                    
                }
                
                controller.swifter = _airportListViewModel!.cityInfo.filter{$0.woeid! != woeid}.filter{$0.name! != ""}
                
                collapseDetailViewController = false
                controller.navigationItem.leftBarButtonItem?.accessibilityIdentifier = "myLeftButton"
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    //MARK: UISearchbar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        _airportListViewModel!.isSearch = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        _airportListViewModel!.isSearch = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        _airportListViewModel!.isSearch = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        _airportListViewModel!.isSearch = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let mSearchText = searchText.trimmingCharacters(in: .whitespaces)
        if (mSearchText.isEmpty) {
            _airportListViewModel!.queue.cancelAllOperations()
            
            _airportListViewModel!.restrictReloadedFilter = 0
            
            _airportListViewModel!.isSearch = false
            
            self.noFoundRecords = false
            
            _airportListViewModel!.cityInfoFilter.removeAll()
            _airportListViewModel!.preservePrviousSearch.removeAll()
            
            self.airportTableView.reloadData()
            
        } else {
            _airportListViewModel!.restrictReloadedFilter = 1
            
            print("***********\(mSearchText)************")
            let citySearchOperation = BlockOperation(block:{
                self._airportListViewModel!.searchAirportByCities(searchString:mSearchText)
            })
            
            citySearchOperation.qualityOfService = .userInitiated
            
            citySearchOperation.completionBlock = {
                if(self._airportListViewModel!.cityInfoFilter.count == 0){
                    self.noFoundRecords = true
                } else {
                    self.noFoundRecords = false
                    
                }
                
                self._airportListViewModel!.isSearch = true
                
                DispatchQueue.main.async {
                    
                    if self._airportListViewModel!.restrictReloadedFilter == 1 {
                        self.airportTableView.reloadData()
                    } else {
                        self._airportListViewModel!.cityInfoFilter.removeAll()
                    }
                }
            }
            _airportListViewModel!.queue.addOperation(citySearchOperation)
        }
    }
}

extension AirportListController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        // Returning true prevents the default of showing the secondary
        // view controller.
        return collapseDetailViewController
    }
}



