//
//  MoonModel.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2021 Dylan Park. All rights reserved.

import Foundation
import UIKit

struct MoonModel {
    
    let cityName: String
    let region: String
    let country: String
    let sunriseTime: String
    let sunsetTime: String
    let moonriseTime: String
    let moonsetTime: String
    let moonPhase: MoonPhase
    let moonIllumination: String
    
    var moonPhaseImage: UIImage {
        switch moonPhase {
        case .NEW_MOON:
            return #imageLiteral(resourceName: "New Moon")
        case .WAXING_CRESCENT:
            return #imageLiteral(resourceName: "Waxing Crescent")
        case .FIRST_QUARTER:
            return #imageLiteral(resourceName: "First Quarter")
        case .WAXING_GIBBOUS:
            return #imageLiteral(resourceName: "Waxing Gibbous")
        case .FULL_MOON:
            return #imageLiteral(resourceName: "Full Moon")
        case .WANING_GIBBOUS:
            return #imageLiteral(resourceName: "Waning Gibbous")
        case .LAST_QUARTER:
            return #imageLiteral(resourceName: "Last Quarter")
        case .WANING_CRESCENT:
            return #imageLiteral(resourceName: "Waning Crescent")
        }
    }
    
}
