//
//  CompletionTableViewController.swift
//  MoonPhase
//
//  Created by Dylan Park on 17/8/21.
//  Copyright © 2021 Dylan Park. All rights reserved.

import UIKit
import MapKit

class AutoCompleteTableViewController: UITableViewController, MKLocalSearchCompleterDelegate {
    
    @IBOutlet weak var autoCompleteTableView: UITableView!
    
    var mapItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var completeMapSearchDelegate: CompleteMapSearch? = nil
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoCompleteTableView.delegate = self
        autoCompleteTableView.dataSource = self
        searchCompleter.delegate = self
        
    }
    
}

//MARK: - MKLocalSearchCompleterDelegate

extension AutoCompleteTableViewController {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        searchCompleter.resultTypes = .address
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
    
}


//MARK: - UISearchResultsUpdating

extension AutoCompleteTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else { return }
        
        searchCompleter.queryFragment = searchBarText
        
        //        let request = MKLocalSearch.Request()
        
        //        request.naturalLanguageQuery = searchBarText
        //        request.resultTypes = .address
        //        request.region = MKCoordinateRegion(.world)
        //
        //        let search = MKLocalSearch(request: request)
        //
        //        search.start { response, error in
        //            guard let response = response else { return }
        //
        //            self.mapItems = response.mapItems
        //            self.autoCompleteTableView.reloadData()
        //        }
    }
    
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        searchCompleter.queryFragment = searchText
    //    }
    
}


// MARK: - UITableViewDataSource

extension AutoCompleteTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResults = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell")
        
        cell?.textLabel?.text = searchResults.title
        cell?.detailTextLabel?.text = searchResults.subtitle
        
        //        if let city = mapItems[indexPath.row].placemark.locality,
        //           let state = mapItems[indexPath.row].placemark.administrativeArea,
        //           let country = mapItems[indexPath.row].placemark.country
        //        {
        //            cell?.textLabel?.text = "\(city), \(country)"
        //        }
        
        return cell!
    }
    
}


//MARK: - UITableViewDelegate

extension AutoCompleteTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        autoCompleteTableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error) in
            guard let selectedItem = response?.mapItems[0].placemark else {
                return
            }
            //            let selectedItem = self.mapItems[indexPath.row].placemark
            self.completeMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
