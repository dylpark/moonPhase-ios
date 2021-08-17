//
//  AlertViewController.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2021 Dylan Park. All rights reserved.

import UIKit
import CoreLocation

class AlertViewController: UIViewController {
    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var searchLocationButton: UIButton!
    @IBOutlet weak var masterStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    
    let colourModel = ColourModel()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLocationButton.addBorders(edges: .top, color: UIColor(named: "Light Grey")!, thickness: 0.5)
        searchLocationButton.addBorders(edges: .top, color: UIColor(named: "Light Grey")!, thickness: 0.5)
        cancelButton.addBorders(edges: .top, color: UIColor(named: "Light Grey")!, thickness: 0.5)
        
        masterStackView.layer.cornerRadius = 10
        masterStackView.layer.borderWidth = 1
        masterStackView.layer.masksToBounds = true
        masterStackView.clipsToBounds = true
        masterStackView.layer.borderColor = colourModel.lightGrey
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "useCurrentLocation" {
            checkLocationAutorisationWithAlert()
        }

    }
    
    
    //MARK: - Alert
    
    func checkLocationAutorisationWithAlert() {
        
        switch locationManager.authorizationStatus {
        
        case .authorizedWhenInUse:
            UserDefaults.standard.set(location: nil)
            
        case .authorizedAlways:
            UserDefaults.standard.set(location: nil)
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .denied:
            showAlert(withTitle: "Access Denied", message: "Location access has previously been denied. You'll need to allow it from Settings > Privacy > Location Services to use this feature. Alternatively, you can search for a location manually. ")
            
        case .restricted:
            showAlert(withTitle: "Access Restricted", message: "Location access has been restricted. You'll need to allow it from Settings > Screen Time > Content & Privacy Restrictions to use this feature. Alternatively, you can search for a location manually. ")
            
        @unknown default:
            showAlert(withTitle: "Error", message: "Something went wrong whilst attempting to access your location. Please check your Settings > Privacy and restart the app.")
        }
    }
    
    func showAlert(withTitle title: String?, message: String?, andActions actions:
                    [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach({alert.addAction($0)})
        
        alert.view.tintColor = .systemBlue
        
        present(alert, animated: true, completion: nil)
    }
    
}

