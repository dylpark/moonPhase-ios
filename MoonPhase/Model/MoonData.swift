//
//  MoonData.swift
//  MoonPhase
//
//  Created by Dylan Park on 23/7/21.
//  Copyright © 2021 Dylan Park. All rights reserved.

import Foundation

struct MoonData: Codable {
    let astronomy: Astronomy
}

struct Astronomy: Codable {
    let astro: Astro
}

struct Astro: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
}
