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
    
    func getMoonIllumination(userSelectedDate: Date) -> String {
        
        let moon = Moon(at: userSelectedDate)
        let illumination = moon.illuminated
        let moonIllumination = "\(String(format: "%.1f", illumination))%"
        
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
