//
//  MapViewController.swift
//  Moon-iOS14
//
//  Created by Dylan Park on 17/6/21.
//
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UISearchControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var searchController: UISearchController? = nil
    let locationManager = CLLocationManager()
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    var selectedPin: MKPlacemark? = nil
    var droppedPin = MKPointAnnotation()
    var selectedLocation = CLLocationCoordinate2D()
    var selectedLocationLabel = String()
    var mapItems: [MKMapItem] = []
    
    enum Segues {
        static let cancel = "cancel"
    }
    
    enum Colours {
        static let backgroundBlue = "Background Blue"
        static let codGrey = "Cod Grey"
        static let superLightGrey = "Super Light Grey"
        static let lightGrey = "Light Grey"
    }
    
    enum Identifiers {
        static let navigationController = "navigationController"
        static let autoCompleteTableViewController = "autoCompleteTableViewController"
    }
    
    enum Strings {
        static let navTitle = "Location Search"
        static let searchBarPlaceholder = "Search"
        static let customSearchFieldKey = "searchField"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        centreViewOnUserLocation()
        configureNavController()
        configureSearchResultsTable()
        configureSearchController()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.cancel {
            UserDefaults.standard.set(location: nil)
            UserDefaults.standard.setLabel(label: nil)
        }
    }
    
    
    //MARK: - View Configuration
    
    func configureNavController() {
        title = Strings.navTitle
        navigationController?.view.isHidden = false
        navigationController?.storyboard?.instantiateViewController(withIdentifier: Identifiers.navigationController)
    }
    
    func configureSearchResultsTable() {
        let autoCompleteTable = storyboard!.instantiateViewController(withIdentifier: Identifiers.autoCompleteTableViewController)
            as! AutoCompleteTableViewController
        
        autoCompleteTable.mapView = mapView
        autoCompleteTable.completeMapSearchDelegate = self
        
        searchController = UISearchController(searchResultsController: autoCompleteTable)
        searchController?.searchResultsUpdater = autoCompleteTable as UISearchResultsUpdating
    }
    
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController?.searchBar.delegate = self
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.showsCancelButton = false
        searchController?.searchBar.barStyle = .black
        searchController?.searchBar.tintColor = .white
        searchController?.searchBar.searchTextField.textColor = .white
        searchController?.searchBar.backgroundColor = UIColor(named: Colours.backgroundBlue)
        searchController?.searchBar.searchTextField.backgroundColor = UIColor(named: Colours.codGrey)
        searchController?.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: Strings.searchBarPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: Colours.superLightGrey)!])
        searchController?.searchBar.setSearchBarIconColorTo(color: UIColor(named: Colours.lightGrey)!)
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


// MARK: - UISearchBarDelegate functions

extension MapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = searchBar.text
        request.resultTypes = .address
        
        let activeSearch = MKLocalSearch(request: request)
        
        activeSearch.start { response, error in
            guard let response = response else { return }
            
            self.mapItems = response.mapItems
            
            let selectedPin = self.mapItems[0].placemark
            self.dropPinZoomIn(placemark: selectedPin)
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - HandleMapSearch Protocol

protocol CompleteMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

extension MapViewController: CompleteMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark) {

        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)

        let droppedPin = MKPointAnnotation()
        droppedPin.coordinate = placemark.coordinate
        
        if let city = placemark.locality,
           let country = placemark.country {
            droppedPin.subtitle = "\(city), \(country)"
            selectedLocationLabel = "\(city)"
        }
        
        mapView.addAnnotation(droppedPin)
        
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let selectedLocation = selectedPin?.coordinate
        
        UserDefaults.standard.set(location: selectedLocation)
        UserDefaults.standard.setLabel(label: self.selectedLocationLabel)
    }
    
}


//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func centreViewOnUserLocation() {
        
        locationManager.delegate = self
        guard let currentLocation = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: currentLocation, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
}
