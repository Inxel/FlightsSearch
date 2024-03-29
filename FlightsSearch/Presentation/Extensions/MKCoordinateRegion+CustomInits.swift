//
//  MKCoordinateRegion+CustomInits.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 02.05.2021.
//

import MapKit

extension MKCoordinateRegion {
    
    init(coordinates: [CLLocationCoordinate2D], spanMultiplier: CLLocationDistance = 1.8) {
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        let maxLocationDegreesValue = 180.0

        for coordinate in coordinates {
            topLeftCoord.longitude = min(topLeftCoord.longitude, coordinate.longitude)
            topLeftCoord.latitude = max(topLeftCoord.latitude, coordinate.latitude)

            bottomRightCoord.longitude = max(bottomRightCoord.longitude, coordinate.longitude)
            bottomRightCoord.latitude = min(bottomRightCoord.latitude, coordinate.latitude)
        }

        let cent = CLLocationCoordinate2D(
            latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5,
            longitude: topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        )
        
        let latitudeDelta = abs(topLeftCoord.latitude - bottomRightCoord.latitude) * spanMultiplier
        let longitudeDelta = abs(bottomRightCoord.longitude - topLeftCoord.longitude) * spanMultiplier
        
        let span = MKCoordinateSpan(
            latitudeDelta: min(latitudeDelta, maxLocationDegreesValue),
            longitudeDelta: min(longitudeDelta, maxLocationDegreesValue)
        )

        self.init(center: cent, span: span)
    }
    
}
