//
//  CompletionTableViewController.swift
//  MoonPhase
//
//  Created by Dylan Park on 17/8/21.
//  Copyright © 2021 Dylan Park. All rights reserved.

import UIKit
import MapKit

class CompletionTableViewController: UIViewController, MKLocalSearchCompleterDelegate {
    
    @IBOutlet weak var completionTableView: UITableView!
    
    var mapItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var searchCompleter = MKLocalSearchCompleter()
    var searchCompletion = [MKLocalSearchCompletion]()
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completionTableView.delegate = self
        completionTableView.dataSource = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        searchCompletion = searchCompleter.results
        completionTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}


// MARK: - TableViewDataSource

extension CompletionTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompletion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchCompletion = searchCompletion[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "completionCell")
        
        cell?.textLabel?.text = searchCompletion.title
        cell?.detailTextLabel?.text = searchCompletion.subtitle
        
        return cell!
    }
}


//MARK: - UITableViewDelegate

extension CompletionTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchCompletion[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            
            print(name)
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            
            print(lat)
            print(lon)
            
        }
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - UISearchResultsUpdating

//extension CompletionTableViewController: UISearchResultsUpdating {
//
//    func updateSearchResults(for searchController: UISearchController) {
//
//        guard let searchBarText = searchController.searchBar.text else
//        { return }
//
//        let request = MKLocalSearch.Request()
//
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
//            self.tableView.reloadData()
//        }
//    }
//
//}


//MARK: - Debouncer

//public class Debouncer {
//
//    private var timeInterval: TimeInterval
//    private var timer: Timer?
//
//    typealias Handler = () -> Void
//    var handler: Handler?
//
//    init(timeInterval: TimeInterval) {
//        self.timeInterval = timeInterval
//    }
//
//    public func renewInterval() {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] (timer) in
//            self?.timeIntervalDidFinish(for: timer)
//        })
//    }
//
//    @objc private func timeIntervalDidFinish(for timer: Timer) {
//        guard timer.isValid else {
//            return
//        }
//
//        handler?()
//        handler = nil
//    }
//
//}
