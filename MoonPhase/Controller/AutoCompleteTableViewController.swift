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
    
    enum Colours {
        static let lightGreyA50 = "Light Grey-A50"
        static let whiteA50 = "White-A50"
        static let whiteA75 = "White-A75"
    }
    
    enum Identifiers {
        static let autoCompleteCell = "autoCompleteCell"
    }
    
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
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.autoCompleteCell)
        
        cell?.textLabel?.text = searchResults.title
        cell?.detailTextLabel?.text = searchResults.subtitle
        cell?.textLabel?.textColor = .white
        cell?.detailTextLabel?.textColor = UIColor(named: Colours.whiteA75)
        
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
            self.completeMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
