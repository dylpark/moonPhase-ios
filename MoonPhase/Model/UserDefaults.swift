//
//  UserDefaults.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2022 Dylan Park. All rights reserved.

import Foundation
import CoreLocation

private struct DefaultsLocation {
    
    fileprivate static let savedLocationKey = "savedLocationKey"
    fileprivate static let savedLocationLabelKey = "savedLocationLabelKey"
    
}

extension UserDefaults {
    
    func set(location: CLLocationCoordinate2D?){
        
        // Save Location
        if let location = location {
            let locationLat = NSNumber(value:location.latitude)
            let locationLon = NSNumber(value:location.longitude)
            self.set(["lat": locationLat, "lon": locationLon], forKey: DefaultsLocation.savedLocationKey)
        } else {
            self.removeObject(forKey: DefaultsLocation.savedLocationKey)
        }
    }
    
    // Load Location
    func location() -> CLLocationCoordinate2D? {
        if let locationDictionary = self.object(forKey: DefaultsLocation.savedLocationKey) as? Dictionary<String,NSNumber> {
            
            let locationLat = locationDictionary["lat"]!.doubleValue
            let locationLon = locationDictionary["lon"]!.doubleValue
            
            return CLLocationCoordinate2D(latitude: locationLat, longitude: locationLon)
        }
        return nil
    }
    
    // Save Label
    func setLabel(label: String?) {
        
        if let label = label {
            self.set(label, forKey: DefaultsLocation.savedLocationLabelKey)
        } else {
            self.removeObject(forKey: DefaultsLocation.savedLocationLabelKey)
        }
        
    }
    
    // Load Label
    func getLabel() -> String? {
        
        return self.string(forKey: DefaultsLocation.savedLocationLabelKey)
        
    }
    
}
