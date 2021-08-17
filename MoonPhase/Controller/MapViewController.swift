//
//  MapViewController.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2021 Dylan Park. All rights reserved.

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: CLLocationDistance = 10000
    var searchController: UISearchController? = nil
    var selectedLocation = CLLocationCoordinate2D()
    var droppedPin = MKPointAnnotation()
    var selectedLocationLabel = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        configureLocationManager()
        centreViewOnUserLocation()
        
        configureCompletionTableView()
        configureNavController()
        configureSearchController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "cancel" {
            UserDefaults.standard.set(location: nil)
            UserDefaults.standard.setLabel(label: nil)
        }
    }
    
    
    //MARK: - View Configuration
    
    func configureNavController() {
        title = "Location Search"
        navigationController?.view.isHidden = false
        navigationController?.view.backgroundColor = UIColor(named: "Background Blue")
        navigationController?.storyboard?.instantiateViewController(withIdentifier: "navigationController")
    }
    
    func configureCompletionTableView() {
        let completionTableView = storyboard!.instantiateViewController(identifier: "completionTableView") as? CompletionTableViewController
        
        completionTableView?.mapView = mapView
        completionTableView?.handleMapSearchDelegate = self
        
        searchController = UISearchController(searchResultsController: completionTableView)
        searchController?.searchResultsUpdater = completionTableView as? UISearchResultsUpdating
    }
    
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController?.delegate = self
        searchController?.searchBar.delegate = self
        definesPresentationContext = true
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        searchController?.searchBar.barStyle = .black
        searchController?.searchBar.tintColor = .white
        searchController?.searchBar.searchTextField.textColor = .white
        searchController?.searchBar.backgroundColor = UIColor(named: "Background Blue")
        searchController?.searchBar.searchTextField.backgroundColor = UIColor(named: "Cod Grey")
        searchController?.searchBar.setSearchBarIconColorTo(color: UIColor(named: "Light Grey")!)
        searchController?.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Super Light Grey")!])
    }
    
    func setSearchIconColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
    
}


//MARK: - UISearchBar Extension

extension UISearchBar {
    
    func setSearchBarIconColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
    
}


//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let centre = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: centre, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centreViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
}


//MARK: - HandleMapSearch Protocol

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

extension MapViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark) {

//        selectedPin = placemark
        
        mapView.removeAnnotations(mapView.annotations)
        
        let userSelectedLocation = MKPointAnnotation()
        userSelectedLocation.coordinate = placemark.coordinate
        
        if let city = placemark.locality,
           let state = placemark.administrativeArea,
           let country = placemark.country {
            userSelectedLocation.subtitle = "\(city) \(state), \(country)"
        }
        mapView.addAnnotation(userSelectedLocation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
}


//MARK: - GMSAutocomplete

//extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
//
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
//                           didAutocompleteWith place: GMSPlace) {
//
//        googleMapsView.clear()
//
//        searchController?.isActive = false
//        searchController?.resignFirstResponder()
//        searchController?.dismiss(animated: true, completion: nil)
//
//        selectedLocation = place.coordinate
//
//        let position = selectedLocation
//        let marker = GMSMarker(position: position)
//        marker.title = place.name
//        marker.map = googleMapsView
//        marker.position = CLLocationCoordinate2D(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
//
//        let camera = GMSCameraPosition.camera(withLatitude: selectedLocation.latitude, longitude: selectedLocation.longitude, zoom: 8.0)
//
//        if place.formattedAddress != nil {
//            self.selectedLocationLabel = place.name!
//        }
//
//        googleMapsView.camera = camera
//        googleMapsView.animate(to: camera)
//
//        UserDefaults.standard.set(location: selectedLocation)
//        UserDefaults.standard.setLabel(label: selectedLocationLabel)
//
//    }
//
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
//                           didFailAutocompleteWithError error: Error){
//        print("lookup place id query error: \(error.localizedDescription)")
//    }
//
//}


//MARK: - UISearchBarDelegate

//extension MapViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        googleMapsView.clear()
//
//        let client = GMSPlacesClient()
//
//        guard let query = searchBar.text else { return }
//
//        let filter = GMSAutocompleteFilter()
//        filter.type = .geocode
//        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
//
//            guard let searchResult = results, error == nil else {
//                return
//            }
//
//            let searchedPlaceID = searchResult[0].placeID
//
//            client.lookUpPlaceID(searchedPlaceID) { place, error in
//                if let error = error {
//                    print("lookup place id query error: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let place = place else {
//                    print("No place details for \(searchedPlaceID)")
//                    return
//                }
//
//                self.searchController?.resignFirstResponder()
//                self.searchController?.dismiss(animated: true, completion: nil)
//                self.selectedLocation = place.coordinate
//
//                let position = self.selectedLocation
//                let marker = GMSMarker(position: position)
//                marker.title = place.name
//                marker.map = self.googleMapsView
//                marker.position = CLLocationCoordinate2D(latitude: self.selectedLocation.latitude, longitude: self.selectedLocation.longitude)
//
//                let camera = GMSCameraPosition.camera(withLatitude: self.selectedLocation.latitude, longitude: self.selectedLocation.longitude, zoom: 8.0)
//
//                if place.formattedAddress != nil {
//                    self.selectedLocationLabel = place.name!
//                }
//
//                self.googleMapsView.camera = camera
//                self.googleMapsView.animate(to: camera)
//
//                UserDefaults.standard.set(location: self.selectedLocation)
//                UserDefaults.standard.setLabel(label: self.selectedLocationLabel)
//            }
//        }
//    }
//
//}
