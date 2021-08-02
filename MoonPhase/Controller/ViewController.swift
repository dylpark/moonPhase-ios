//
//  ViewController.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2021 Dylan Park. All rights reserved.

import UIKit
import CoreLocation
import MapKit
import GooglePlaces

class ViewController: UIViewController {
    
    @IBOutlet weak var phaseImageView: UIImageView!
    @IBOutlet weak var phaseLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var moonriseLabel: UILabel!
    @IBOutlet weak var moonsetLabel: UILabel!
    @IBOutlet weak var moonIlluminationLabel: UILabel!
    @IBOutlet weak var newMoonCounterLabel: UILabel!
    @IBOutlet weak var fullMoonCounterLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var moonManager = MoonManager()
    var phaseManager = PhaseManager()
    let locationManager = CLLocationManager()
    var locationManagerAuthorizing = false
    var userSelectedDate = Date()
    let dateFormatter = DateFormatter()
    let requestedDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moonManager.delegate = self
        locationManager.delegate = self
        
        dateFormatter.dateFormat = "EEE, d MMM"
        dateLabel.text = dateFormatter.string(from: userSelectedDate)

        initialiseLocationServices()
        initialLocationAuthCheck()
        
    }
    
}

//MARK: - MoonManagerDelegate
extension ViewController: MoonManagerDelegate {
    
    func didUpdateMoon(_ moonManager: MoonManager, moon: MoonModel) {
        DispatchQueue.main.async {
            
            self.sunriseLabel.text = moon.sunriseTime
            self.sunsetLabel.text = moon.sunsetTime
            self.moonriseLabel.text = moon.moonriseTime
            self.moonsetLabel.text = moon.moonsetTime
            self.phaseLabel.text = moon.moonPhase.rawValue
            self.moonIlluminationLabel.text = "\(moon.moonIllumination)%"
            self.phaseImageView.image = moon.moonPhaseImage
            self.newMoonCounterLabel.text
                = String("\(Int(ceil(self.phaseManager.getDaysUntilPhase(userSelectedDate: self.userSelectedDate, nextPhase: "New Moon")))) days")
            self.fullMoonCounterLabel.text
                = String("\(Int(ceil(self.phaseManager.getDaysUntilPhase(userSelectedDate: self.userSelectedDate, nextPhase: "Full Moon")))) days")
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - Location Services
extension ViewController: CLLocationManagerDelegate {
    
    //MARK: - Initialise Location Services
    
    func initialiseLocationServices() {
        
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
    }
    
    func initialLocationAuthCheck() {
        
        if UserDefaults.standard.location() != nil {
            fetchMoonForManualLocation()
            
        } else {
            switch locationManager.authorizationStatus {
            
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.requestLocation()
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                locationManagerAuthorizing = true
                
            case .restricted, .denied:
                fetchMoonForManualLocation()
                
            @unknown default:
                fetchMoonForManualLocation()
            }
        }
        
    }
    
    //MARK: - didUpdateLocations()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if UserDefaults.standard.location() == nil {
            fetchMoonForCurrentLocation(locations: locations)
        }
        
    }
    
    //MARK: - Authorisation Status
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if (locationManagerAuthorizing) {
            switch manager.authorizationStatus {
            
            case .authorizedWhenInUse, .authorizedAlways:
                UserDefaults.standard.set(location: nil)
                locationManager.requestLocation()
                
            case .notDetermined, .restricted, .denied:
                locationManager.requestLocation()
                fetchMoonForManualLocation()
            @unknown default:
                fetchMoonForManualLocation()
            }
        }
        locationManagerAuthorizing = false
        
    }
    
    
    //MARK: - Current Location
    
    func fetchMoonForCurrentLocation(locations: [CLLocation]) {
        
        activityIndicator.startAnimating()
        
        requestedDateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            moonManager.fetchMoon(latitude: lat,
                                  longitude: lon,
                                  date: requestedDateFormatter.string(from: userSelectedDate))
            
            getPlace(for: location) { placemark in
                guard let placemark = placemark else { return }
                
                if placemark.locality != nil {
                    self.cityLabel.text! = (String(describing: placemark.locality!))
                } else {
                    self.cityLabel.text = "Location"
                }
            }
        }
        
    }
    
    //MARK: - Current Location - Label
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
    
    //MARK: - Manual Location
    
    func fetchMoonForManualLocation() {
        
        activityIndicator.startAnimating()
        
        requestedDateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let location = UserDefaults.standard.location() {
            
            moonManager.fetchMoon(latitude: location.latitude,
                                  longitude: location.longitude,
                                  date: requestedDateFormatter.string(from: userSelectedDate))
            
            if let locationLabel = UserDefaults.standard.getLabel() {
                self.cityLabel.text! = locationLabel
            } else {
                self.cityLabel.text! = "Error"
            }
            
        } else if UserDefaults.standard.location() == nil {
            
            let HardCodedLocation = CLLocation(latitude: -33.865143, longitude: 151.209900)
            
            moonManager.fetchMoon(latitude: HardCodedLocation.coordinate.latitude,
                                  longitude: HardCodedLocation.coordinate.longitude,
                                  date: requestedDateFormatter.string(from: userSelectedDate))
            
            getPlace(for: HardCodedLocation) { placemark in
                guard let placemark = placemark else { return }
                
                if placemark.locality != nil {
                    self.cityLabel.text! = (String(describing: placemark.locality!))
                } else {
                    self.cityLabel.text = "Error"
                }
            }
        }
        
    }
    
    //MARK: - didFailWithError()
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
