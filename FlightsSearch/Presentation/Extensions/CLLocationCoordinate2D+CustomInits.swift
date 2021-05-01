//
//  CLLocationCoordinate2D+CustomInits.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 01.05.2021.
//

import MapKit

extension CLLocationCoordinate2D {
    
    init(place: PlacePM) {
        self.init(latitude: place.location.latitude, longitude: place.location.longitude)
    }
    
    init(location: LocationPM) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
    
}
