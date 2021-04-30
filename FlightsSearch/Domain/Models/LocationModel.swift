//
//  LocationModel.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 30.04.2021.
//

import Foundation

struct LocationModel {
    let latitude: Double
    let longitude: Double
}

extension LocationModel {
    
    init(locationDTO: LocationDTO) {
        latitude = locationDTO.latitude
        longitude = locationDTO.longitude
    }
    
}
