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
//        var age: Double = moon.age
//        let illumination: Double = moon.illuminated
        var currentPhase: MoonPhase
        let moonPhase = (moon.age, moon.illuminated)
        
        switch moonPhase {
        case (0...1.84566, 0.0...1.0):
            currentPhase = .newMoon
            
        case (1.84566...5.53699, 1.0...49.0):
            currentPhase = .waxingCrescent
            
        case (5.53699...9.22831, 49.0...51.0):
            currentPhase = .firstQuarter
            
        case (9.22831...12.91963, 51.0...99.0):
            currentPhase = .waxingGibbous
            
        case (12.91963...16.61096, 99.0...100.0):
            currentPhase = .fullMoon
            
        case (16.61096...20.30228, 99.0...51.0):
            currentPhase = .waningGibbous
            
        case (20.30228...23.99361, 51.0...49.0):
            currentPhase = .lastQuarter

        case (23.99361...27.68493, 49.0...1.0):
            currentPhase = .waningCrescent
        default:
            currentPhase = .newMoon
        }
        
        print(String(describing: moon))
        return currentPhase.rawValue
        
        /* Declaration
         
         let cycleIndex: Double
         Discussion
         
         A full lunar cycle is represented by the range 0..<1
         Transitions occur at:
         0.00 = New moon
         0.25 = First quarter
         0.50 = Full moon
         0.75 = Second quarter
         Phases are in the ranges:
         0.00..<0.25 = Waxing crescent
         0.25..<0.50 = Waxing gibbous
         0.50..<0.75 = Waning gibbous
         0.75..<1.00 = Waning crescent
         
         */
        
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
        
        //        switch age {
        //        case 0...1.84566:
        //            currentPhase = .newMoon
        //        case 1.84566...5.53699:
        //            currentPhase = .waxingCrescent
        //        case 5.53699...9.22831:
        //            currentPhase = .firstQuarter
        //        case 9.22831...12.91963:
        //            currentPhase = .waxingGibbous
        //        case 12.91963...16.61096:
        //            currentPhase = .fullMoon
        //        case 16.61096...20.30228:
        //            currentPhase = .waningGibbous
        //        case 20.30228...23.99361:
        //            currentPhase = .lastQuarter
        //        case 23.99361...29.53058868:
        //            currentPhase = .waningCrescent
        //        default:
        //            currentPhase = .newMoon
        //        }
        
        
        //        switch age {
        //        case 0...0.5:
        //            currentPhase = .newMoon
        //        case 0.5...6.38264692644:
        //            currentPhase = .waxingCrescent
        //        case 6.38264692644...9.22831:
        //            currentPhase = .firstQuarter
        //        case 9.22831...13.76529385288:
        //            currentPhase = .waxingGibbous
        //        case 13.76529385288...15.76529385288:
        //            currentPhase = .fullMoon
        //        case 15.76529385288...20.30228:
        //            currentPhase = .waningGibbous
        //        case 20.30228...23.99361:
        //            currentPhase = .lastQuarter
        //        case 23.99361...29.53058868:
        //            currentPhase = .waningCrescent
        //        default:
        //            currentPhase = .newMoon
        //        }
        
        //
        //        if (cycleIndex == 0.0) {
        //            currentPhase = .newMoon
        //        } else if (cycleIndex < 0.25) {
        //            currentPhase = .waxingCrescent
        //        } else if (cycleIndex == 0.25) {
        //            currentPhase = .firstQuarter
        //        } else if (cycleIndex < 0.5) {
        //            currentPhase = .waxingGibbous
        //        } else if (cycleIndex == 0.5) {
        //            currentPhase = .fullMoon
        //        } else if (cycleIndex < 0.75) {
        //            currentPhase = .waningGibbous
        //        } else if (cycleIndex == 0.75) {
        //            currentPhase = .lastQuarter
        //        } else if (cycleIndex < 1.00) {
        //            currentPhase = .waningCrescent
        //        } else {
        //            currentPhase = .newMoon
        //        }
        
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
