//
//  MoonData.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2022 Dylan Park. All rights reserved.

import Foundation

struct MoonData: Codable {
    let location: Location
    let astronomy: Astronomy
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
}

struct Astronomy: Codable {
    let astro: Astro
}

struct Astro: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moon_phase: String
    let moon_illumination: String
}
