//
//  LocationPM.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

struct LocationPM {
    let latitude: Double
    let longitude: Double
}

extension LocationPM {
    
    init(locationModel: LocationModel) {
        latitude = locationModel.latitude
        longitude = locationModel.longitude
    }
    
}

extension LocationPM: Equatable {
    
    static func == (lhs: LocationPM, rhs: LocationPM) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
}
