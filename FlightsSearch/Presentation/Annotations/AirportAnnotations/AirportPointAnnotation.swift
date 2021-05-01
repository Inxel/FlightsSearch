//
//  AirportPointAnnotation.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 01.05.2021.
//

import MapKit

final class AirportPointAnnotation: MKPointAnnotation {
    
    // MARK: - Properties
    
    private var place: PlacePM
    
    // MARK: - Init
    
    init(place: PlacePM) {
        self.place = place
        super.init()
        coordinate = CLLocationCoordinate2D(place: place)
        title = place.iata
    }
    
}
