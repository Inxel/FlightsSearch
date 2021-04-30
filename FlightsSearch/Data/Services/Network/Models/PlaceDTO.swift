//
//  PlaceDTO.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

struct PlaceDTO: Decodable {
    let name: String
    let airportName: String?
    let iata: String
    let location: LocationDTO
    
    private enum CodingKeys: String, CodingKey {
        case name
        case airportName = "airport_name"
        case iata
        case location
    }
}
