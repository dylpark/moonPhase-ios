//
//  MoonTool.swift
//  MoonPhase
//
//  Created by Dylan Park on 30/8/21.
//

import Foundation
import MoonTool

struct MoonTool {
    
    func getMoonPhase(userSelectedDate: Date) -> String {
        
        let moon = Moon(at: userSelectedDate)
        
        var currentPhase: String {
            switch moon.age {
            case 0...1:
                return MoonPhase.NEW_MOON.rawValue
                
            case 1...6.38264692644:
                return MoonPhase.WAXING_CRESCENT.rawValue
                
            case 6.38264692644...8.38264692644:
                return MoonPhase.FIRST_QUARTER.rawValue
                
            case 8.38264692644...13.76529385288:
                return MoonPhase.WAXING_GIBBOUS.rawValue
                
            case 13.76529385288...15.76529385288:
                return MoonPhase.FULL_MOON.rawValue
                
            case 15.76529385288...21.14794077932:
                return MoonPhase.WANING_GIBBOUS.rawValue
                
            case 21.14794077932...23.14794077932:
                return MoonPhase.LAST_QUARTER.rawValue
                
            case 23.14794077932...28.53058770576:
                return MoonPhase.WANING_CRESCENT.rawValue
                
            case 28.53058770576...29.53058868:
                return MoonPhase.NEW_MOON.rawValue
                
            default:
                return "Error"
            }
        }
        return currentPhase
    }
    
    func getMoonIllumination(userSelectedDate: Date) -> String {
        
        let moon = Moon(at: userSelectedDate)
        let illumination = moon.illuminated
        let moonIllumination = "\(String(format: "%.0f", illumination))%"
        
        return moonIllumination
    }
    
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy/MM/dd HH:mm"
//    let someDateTime = formatter.date(from: "2021/03/29 12:00")
//    var currentPhase = String()
//
//    let now = someDateTime!
//    let moon = Moon(at: now)
//
//    print(String(describing: moon))
//    print(String(describing: moon.illuminated))
//    print(String(describing: moon.age))
//
//    print(String(ceil(moon.illuminated)))
    
}
