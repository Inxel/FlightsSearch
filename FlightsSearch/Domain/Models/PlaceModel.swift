//
//  PlaceModel.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 30.04.2021.
//

import Foundation

struct PlaceModel {
    let name: String
    let airportName: String?
    let iata: String
    let cityIata: String?
    let location: LocationModel
    let query: String
}

extension PlaceModel {
    
    init(placeDTO: PlaceDTO, query: String = "") {
        name = placeDTO.name
        airportName = placeDTO.airportName
        iata = placeDTO.iata
        cityIata = placeDTO.cityIata
        location = LocationModel(locationDTO: placeDTO.location)
        self.query = query
    }
    
}
