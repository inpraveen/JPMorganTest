//
//  Planet.swift
//  JPMorganTest
//
//  Created by Praveen Kumar on 27/04/23.
//

import Foundation

// MARK: - Planet

struct Planet: Codable {
    
    let name: String
    let rotationPeriod: String
    let orbitalPeriod: String
    let diameter: String
    let climate: String
    let gravity: String
    let terrain: String
    let surfaceWater: String
    let population: String
    let residents: [String]
    let films: [String]
    let created: String
    let edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, diameter, climate, gravity, terrain, population, residents, films, created, edited, url
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case surfaceWater = "surface_water"
    }
}

// MARK: - PlanetResult

struct PlanetResult: Codable {
    
    let results: [Planet]
}
