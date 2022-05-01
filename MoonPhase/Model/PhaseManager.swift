//
//  PhaseCalculation.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2022 Dylan Park. All rights reserved.

import Foundation

class PhaseManager {

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

    let fractionOfCycle = [
        0...0.033863193308711                   : "New Moon",
        0.033863193308711...0.216136806691289   : "Waxing Crescent",
        0.216136806691289...0.283863193308711   : "First Quarter",
        0.283863193308711...0.466136806691289   : "Waxing Gibbous",
        0.466136806691289...0.533863193308711   : "Full Moon",
        0.533863193308711...0.716136806691289   : "Waning Gibbous",
        0.716136806691289...0.783863193308711   : "Last Quarter",
        0.783863193308711...0.966136806691289   : "Waning Crescent",
        0.966136806691289...1                   : "New Moon"
    ]

    let lunarCycleInDays = 29.53058770576
    let lunarSecs = 2551442.7777776644
    let firstNewMoon2000 = Date(timeIntervalSince1970: 947182440)

    func getAgeOfPhaseInDays(userSelectedDate: Date) -> Double {

        let totalSecs = userSelectedDate.timeIntervalSince1970 - firstNewMoon2000.timeIntervalSince1970
        var secsInCurrentCycle = totalSecs.truncatingRemainder(dividingBy: lunarSecs)

        if secsInCurrentCycle < 0 {
            secsInCurrentCycle += lunarSecs
        }
        let currentFractionOfCycle = secsInCurrentCycle / lunarSecs
        return currentFractionOfCycle * lunarCycleInDays
    }

    func getPhaseForDate(userSelectedDate: Date) -> String {

        let currentAgeInDays = getAgeOfPhaseInDays(userSelectedDate: userSelectedDate)
        return ageInDays.first { phaseRange, phaseName in
            phaseRange.contains(currentAgeInDays)
        }!.value
    }

    func getDaysUntilPhase(userSelectedDate: Date, nextPhase: String) -> Double {
        
        let currentAgeInDays = getAgeOfPhaseInDays(userSelectedDate: userSelectedDate)
        let nextNewOrFullPhase = ageInDays.first { dayRange, phaseName in
            if (phaseName == nextPhase) {
                if (dayRange.contains(currentAgeInDays)) {
                    return true
                } else if (currentAgeInDays < dayRange.lowerBound) {
                    return true
                }
            }
            return false
        }?.key
        
        if (nextNewOrFullPhase == nil) {
            let timeUntilEndOfPhase = lunarCycleInDays - currentAgeInDays
            let startOfNextCycle = userSelectedDate.addingTimeInterval((timeUntilEndOfPhase * 86400) + 1)
            return lunarCycleInDays - currentAgeInDays + getDaysUntilPhase(userSelectedDate: startOfNextCycle, nextPhase: nextPhase)
        } else if (nextNewOrFullPhase!.contains(currentAgeInDays)) {
            return 0
        } else {
            return nextNewOrFullPhase!.lowerBound - currentAgeInDays
        }
    }
    
}

