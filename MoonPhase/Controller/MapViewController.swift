//
//  MapViewController.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2021 Dylan Park. All rights reserved.

import UIKit
import MapKit
import CoreLocation
import GooglePlaces
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMapsView: GMSMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: CLLocationDistance = 10000
    var searchController: UISearchController?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var resultView: UITextView?
    var selectedLocation = CLLocationCoordinate2D()
    var droppedPin = MKPointAnnotation()
    var selectedLocationLabel = String()
    
    enum Segue {
        static let cancel = "cancel"
    }
    
    enum Colour {
        static let backgroundBlue = "Background Blue"
        static let codGrey = "Cod Grey"
        static let superLightGrey = "Super Light Grey"
        static let lightGrey = "Light Grey"
    }
    
    enum Identifier {
        static let navigationController = "navigationController"
        static let autoCompleteTableViewController = "autoCompleteTableViewController"
    }
    
    enum Text {
        static let navTitle = "Location Search"
        static let searchBarPlaceholder = "Search"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavController()
        configureResultsViewController()
        configureSearchController()
        configureGMSMapView()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.cancel {
            UserDefaults.standard.set(location: nil)
            UserDefaults.standard.setLabel(label: nil)
        }
    }
    
    //MARK: - View Configuration
    
    func configureGMSMapView() {
        
        locationManager.delegate = self
        guard let location = locationManager.location?.coordinate else { return }
        
        var camera = GMSCameraPosition()
        camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 8.0)
        
        googleMapsView.camera = camera
        googleMapsView.settings.myLocationButton = true
        googleMapsView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        googleMapsView.isMyLocationEnabled = true
        googleMapsView.animate(to: camera)
        
    }
    
    //MARK: - View Configuration
    
    func configureNavController() {
        title = Text.navTitle
        navigationController?.view.isHidden = false
        navigationController?.view.backgroundColor = UIColor(named: Colour.backgroundBlue)
        navigationController?.storyboard?.instantiateViewController(withIdentifier: Identifier.navigationController)
    }
    
    func configureResultsViewController() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        resultsViewController?.tableCellBackgroundColor = UIColor(named: Colour.backgroundBlue) ?? .systemBackground
        resultsViewController?.primaryTextColor = .lightGray
        resultsViewController?.primaryTextHighlightColor = .white
        resultsViewController?.secondaryTextColor = .white
        resultsViewController?.tableCellSeparatorColor = .lightGray
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.delegate = self
        searchController?.searchBar.barStyle = .black
        searchController?.searchBar.tintColor = .white
        searchController?.searchBar.searchTextField.textColor = .white
        searchController?.searchBar.backgroundColor = UIColor(named: Colour.backgroundBlue)
        searchController?.searchBar.searchTextField.backgroundColor = UIColor(named: Colour.codGrey)
        searchController?.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: Text.searchBarPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: Colour.superLightGrey)!])
        searchController?.searchBar.setSearchBarIconColorTo(color: UIColor(named: Colour.lightGrey)!)
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.sizeToFit()
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setSearchIconColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
    
}

extension UISearchBar {
    
    func setSearchBarIconColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
    
}

//MARK: - GMSAutocomplete

extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        googleMapsView.clear()
        
        searchController?.isActive = false
        searchController?.resignFirstResponder()
        searchController?.dismiss(animated: true, completion: nil)
        
        selectedLocation = place.coordinate
        
        let position = selectedLocation
        let marker = GMSMarker(position: position)
        marker.title = place.name
        marker.map = googleMapsView
        marker.position = CLLocationCoordinate2D(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: selectedLocation.latitude, longitude: selectedLocation.longitude, zoom: 8.0)
        
        if place.formattedAddress != nil {
            self.selectedLocationLabel = place.name!
        }
        
        googleMapsView.camera = camera
        googleMapsView.animate(to: camera)
        
        UserDefaults.standard.set(location: selectedLocation)
        UserDefaults.standard.setLabel(label: selectedLocationLabel)
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        print("lookup place id query error: \(error.localizedDescription)")
    }
    
}

//MARK: - UISearchBarDelegate

extension MapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        googleMapsView.clear()
        
        let client = GMSPlacesClient()
        
        guard let query = searchBar.text else { return }
        
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
            
            guard let searchResult = results, error == nil else {
                return
            }
            
            let searchedPlaceID = searchResult[0].placeID
            
            client.lookUpPlaceID(searchedPlaceID) { place, error in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                
                guard let place = place else {
                    print("No place details for \(searchedPlaceID)")
                    return
                }
                
                self.searchController?.resignFirstResponder()
                self.searchController?.dismiss(animated: true, completion: nil)
                self.selectedLocation = place.coordinate
                
                let position = self.selectedLocation
                let marker = GMSMarker(position: position)
                marker.title = place.name
                marker.map = self.googleMapsView
                marker.position = CLLocationCoordinate2D(latitude: self.selectedLocation.latitude, longitude: self.selectedLocation.longitude)
                
                let camera = GMSCameraPosition.camera(withLatitude: self.selectedLocation.latitude, longitude: self.selectedLocation.longitude, zoom: 8.0)
                
                if place.formattedAddress != nil {
                    self.selectedLocationLabel = place.name!
                }
                
                self.googleMapsView.camera = camera
                self.googleMapsView.animate(to: camera)
                
                UserDefaults.standard.set(location: self.selectedLocation)
                UserDefaults.standard.setLabel(label: self.selectedLocationLabel)
            }
        }
    }
    
}
