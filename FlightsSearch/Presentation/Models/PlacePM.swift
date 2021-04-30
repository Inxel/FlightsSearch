//
//  PlacePM.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit

struct PlacePM {
    let city: NSAttributedString
    let airport: NSAttributedString
    let iata: String
    let location: LocationPM
}

extension PlacePM {
    
    init(place: PlaceModel) {
        let cityAttributedText = NSMutableAttributedString(string: place.name)
        let airportName = place.airportName ?? "Any airport"
        let airportAttributedText = NSMutableAttributedString(string: airportName)
        let cityRange = (place.name.lowercased() as NSString).range(of: place.query.lowercased())
        let airportRange = (airportName.lowercased() as NSString).range(of: place.query.lowercased())
        
        cityAttributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: cityRange)
        airportAttributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: airportRange)
        
        city = cityAttributedText
        airport = airportAttributedText
        iata = place.iata
        location = LocationPM(locationModel: place.location)
    }
    
}

// MARK: - Equatable

extension PlacePM: Equatable {
    
    static func == (lhs: PlacePM, rhs: PlacePM) -> Bool {
        return lhs.location == rhs.location
    }
    
}
