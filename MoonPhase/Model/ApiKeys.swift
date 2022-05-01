//
//  ApiKeys.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2022 Dylan Park. All rights reserved.

import Foundation

let apiKeys = ApiKeys()

struct ApiKeys {
    
    var placesApiKey: String {
      get {
        
        guard let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") else {
          fatalError("Couldn't find file 'ApiKeys.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "PLACES_API") as? String else {
          fatalError("Couldn't find key 'PLACES_API' in 'ApiKeys.plist'.")
        }
        return value
      }
    }

    var weatherApiKey: String {
      get {
        
        guard let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") else {
          fatalError("Couldn't find file 'ApiKeys.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "WEATHER_API") as? String else {
          fatalError("Couldn't find key 'WEATHER_API' in 'ApiKeys.plist'.")
        }
        return value
      }
    }
    
    var mapsApiKey: String {
      get {
        
        guard let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") else {
          fatalError("Couldn't find file 'ApiKeys.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "MAPS_API") as? String else {
          fatalError("Couldn't find key 'MAPS_API' in 'ApiKeys.plist'.")
        }
        return value
      }
    }
    
}
