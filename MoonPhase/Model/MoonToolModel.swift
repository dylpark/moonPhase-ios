//
//  MoonTool.swift
//  MoonPhase
//
//  Created by Dylan Park on 30/8/21.
//  Copyright © 2021 Dylan Park. All rights reserved.

import Foundation
import MoonTool
import UIKit

struct MoonToolModel {
    
    //MARK: - Moon Phase Title & Image
    
    func getMoonPhase(userSelectedDate: Date) -> String {
        
        let moon = Moon(at: userSelectedDate)
        let age: Double = moon.age
        var phase: MoonPhase
        
        if (age < 1.84566) {
            phase = .newMoon
        } else if (age < 5.53699) {
            phase = .waxingCrescent
        } else if (age < 9.22831) {
            phase = .firstQuarter
        } else if (age < 12.91963) {
            phase = .waxingGibbous
        } else if (age < 16.61096) {
            phase = .fullMoon
        } else if (age < 20.30228) {
            phase = .waningGibbous
        } else if (age < 23.99361) {
            phase = .lastQuarter
        } else if (age < 27.68493) {
            phase = .waningCrescent
        } else {
            phase = .newMoon
        }
        
        return phase.rawValue
    }
    
    //MARK: - Phase Image
    
//    func getPhaseImageView(userSelectedDate: Date) -> UIImage {
//        
//        let moon = Moon(at: userSelectedDate)
//        let illumination = moon.illuminated
//        
//        var moonPhaseImage: UIImage {
//            switch illumination {
//            case .newMoon:
//                return #imageLiteral(resourceName: "New Moon")
//            case .waxingCrescent:
//                return #imageLiteral(resourceName: "Waxing Crescent")
//            case .firstQuarter:
//                return #imageLiteral(resourceName: "Last Quarter")
//            case .waxingGibbous:
//                return #imageLiteral(resourceName: "Waxing Gibbous")
//            case .fullMoon:
//                return #imageLiteral(resourceName: "Full Moon")
//            case .waningGibbous:
//                return #imageLiteral(resourceName: "Waning Gibbous")
//            case .lastQuarter:
//                return #imageLiteral(resourceName: "First Quarter")
//            case .waningCrescent:
//                return #imageLiteral(resourceName: "Waning Crescent")
//            }
//        }
//        return moonPhaseImage
//        
//    }
    
    //MARK: - Moon Illumination %
    
    func getMoonIllumination(userSelectedDate: Date) -> String {
        
        let moon = Moon(at: userSelectedDate)
        let illumination = moon.illuminated
        let moonIllumination = "\(String(Int(round(illumination))))%"
        
        return moonIllumination
    }
    
    //MARK: - Phase for Date
    
    func getPhaseForDate(userSelectedDate: Date) -> String {
        
        let moon = Moon(at: userSelectedDate)
        let age: Double = moon.age
        
        let ageInDays = [
            0...1                                   : "New Moon",
            1...6.38264692644                       : "Waxing Crescent",
            6.38264692644...8.38264692644           : "First Quarter",
            8.38264692644...13.76529385288          : "Waxing Gibbous",
            13.76529385288...15.76529385288         : "Full Moon",
            14.76529385288...21.14794077932         : "Waning Gibbous",
            21.14794077932...23.14794077932         : "Last Quarter",
            23.14794077932...28.53058770576         : "Waning Crescent",
            28.53058770576...29.53058770576         : "New Moon"
        ]

        return ageInDays.first { phaseRange, phaseName in
            phaseRange.contains(age)
        }!.value
    }
    
}
