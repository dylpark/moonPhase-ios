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
        case .newMoon:
            return #imageLiteral(resourceName: "New Moon")
        case .waxingCrescent:
            return #imageLiteral(resourceName: "Waxing Crescent")
        case .firstQuarter:
            return #imageLiteral(resourceName: "First Quarter")
        case .waxingGibbous:
            return #imageLiteral(resourceName: "Waxing Gibbous")
        case .fullMoon:
            return #imageLiteral(resourceName: "Full Moon")
        case .waningGibbous:
            return #imageLiteral(resourceName: "Waning Gibbous")
        case .lastQuarter:
            return #imageLiteral(resourceName: "Last Quarter")
        case .waningCrescent:
            return #imageLiteral(resourceName: "Waning Crescent")
        }
    }
    
}
