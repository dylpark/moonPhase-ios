//
//  MoonManager.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2021 Dylan Park. All rights reserved.

import Foundation
import CoreLocation

protocol MoonManagerDelegate {
    func didUpdateMoon(_ moonManager: MoonManager, moon: MoonModel)
    func didFailWithError(error: Error)
}

struct MoonManager {
    
    let moonURL
        = "https://api.weatherapi.com/v1/astronomy.json?key=\(apiKeys.weatherApiKey)"
    
    var delegate: MoonManagerDelegate?
    
    func fetchMoon(cityName: String, date: String) {
        let urlString = "\(moonURL)&q=\(cityName)&dt=\(date)"
        performRequest(with: urlString)
    }
    
    func fetchMoon(latitude: CLLocationDegrees, longitude: CLLocationDegrees, date: String) {
        let urlString = "\(moonURL)&q=\(latitude),\(longitude)&dt=\(date)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let moon = self.parseJSON(safeData) {
                        self.delegate?.didUpdateMoon(self, moon: moon)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ moonData: Data) -> MoonModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MoonData.self, from: moonData)
            
            let cityName = decodedData.location.name
            let region = decodedData.location.region
            let country = decodedData.location.country
            let sunrise = decodedData.astronomy.astro.sunrise
            let sunset = decodedData.astronomy.astro.sunset
            let moonrise = decodedData.astronomy.astro.moonrise
            let moonset = decodedData.astronomy.astro.moonset
            let moon_phase = decodedData.astronomy.astro.moon_phase
            let moon_illumination = decodedData.astronomy.astro.moon_illumination
            
            let moon = MoonModel(
                cityName: cityName,
                region: region,
                country: country,
                sunriseTime: sunrise,
                sunsetTime: sunset,
                moonriseTime: moonrise,
                moonsetTime: moonset,
                moonPhaseNames: MoonPhaseNames(rawValue: moon_phase)!,
                moonIllumination: moon_illumination
            )
            
            return moon
                      
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
