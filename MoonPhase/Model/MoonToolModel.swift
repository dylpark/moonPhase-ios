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
        var currentPhase: MoonPhase
        
            switch age {
            case 0...0.5:
                currentPhase = .newMoon
            case 0.5...6.38264692644:
                currentPhase = .waxingCrescent
            case 6.38264692644...9.22831:
                currentPhase = .firstQuarter
            case 9.22831...13.76529385288:
                currentPhase = .waxingGibbous
            case 13.76529385288...15.76529385288:
                currentPhase = .fullMoon
            case 15.76529385288...20.30228:
                currentPhase = .waningGibbous
            case 20.30228...23.99361:
                currentPhase = .lastQuarter
            case 23.99361...29.53058868:
                currentPhase = .waningCrescent
            default:
                currentPhase = .newMoon
            }
        
//        if (age < 1.84566) {
//            currentPhase = .newMoon
//        } else if (age < 5.53699) {
//            currentPhase = .waxingCrescent
//        } else if (age < 9.22831) {
//            currentPhase = .firstQuarter
//        } else if (age < 12.91963) {
//            currentPhase = .waxingGibbous
//        } else if (age < 16.61096) {
//            currentPhase = .fullMoon
//        } else if (age < 20.30228) {
//            currentPhase = .waningGibbous
//        } else if (age < 23.99361) {
//            currentPhase = .lastQuarter
//        } else if (age < 27.68493) {
//            currentPhase = .waningCrescent
//        } else {
//            currentPhase = .newMoon
//        }
        
        print(moon.cycleIndex)
        return currentPhase.rawValue
    
    }
    
    //MARK: - Phase Image
    
    func getPhaseImageView(userSelectedDate: Date) -> UIImage {
        
        let moon = Moon(at: userSelectedDate)
        let age: Double = moon.age
        var currentPhase: MoonPhase
        
        if (age < 1.84566) {
            currentPhase = .newMoon
        } else if (age < 5.53699) {
            currentPhase = .waxingCrescent
        } else if (age < 9.22831) {
            currentPhase = .firstQuarter
        } else if (age < 12.91963) {
            currentPhase = .waxingGibbous
        } else if (age < 16.61096) {
            currentPhase = .fullMoon
        } else if (age < 20.30228) {
            currentPhase = .waningGibbous
        } else if (age < 23.99361) {
            currentPhase = .lastQuarter
        } else if (age < 27.68493) {
            currentPhase = .waningCrescent
        } else {
            currentPhase = .newMoon
        }
        
        var moonPhaseImage: UIImage {
            switch currentPhase {
            case .newMoon:
                return #imageLiteral(resourceName: "New Moon")
            case .waxingCrescent:
                return #imageLiteral(resourceName: "Waxing Crescent")
            case .firstQuarter:
                return #imageLiteral(resourceName: "Last Quarter")
            case .waxingGibbous:
                return #imageLiteral(resourceName: "Waxing Gibbous")
            case .fullMoon:
                return #imageLiteral(resourceName: "Full Moon")
            case .waningGibbous:
                return #imageLiteral(resourceName: "Waning Gibbous")
            case .lastQuarter:
                return #imageLiteral(resourceName: "First Quarter")
            case .waningCrescent:
                return #imageLiteral(resourceName: "Waning Crescent")
            }
        }
        return moonPhaseImage
        
    }
    
    //MARK: - Moon Illumination %
    
    func getMoonIllumination(userSelectedDate: Date) -> String {
        
        let moon = Moon(at: userSelectedDate)
        let illumination = moon.illuminated
        let moonIllumination = "\(String(format: "%.1f", illumination))%"
        
        return moonIllumination
    }
    
    //MARK: - Date for next New Moon
    
    //MARK: - Date for next Full Moon
    
}
