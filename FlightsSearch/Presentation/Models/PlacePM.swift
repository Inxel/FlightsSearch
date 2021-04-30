//
//  PlacePM.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit

struct PlacePM {
    let city: NSAttributedString
    let title: NSAttributedString
    let iata: String
    let location: LocationPM
}

extension PlacePM {
    
    init(place: PlaceModel) {
        let cityAttributedText = NSMutableAttributedString(string: place.name)
        let titleAttributedText = NSMutableAttributedString(string: place.airportName ?? "Any airport")
        let cityRange = (place.name as NSString).range(of: place.query)
        let titleRange = (place.airportName as NSString?)?.range(of: place.query)
        
        cityAttributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: cityRange)
        
        if let range = titleRange {
            titleAttributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
        }
        
        city = cityAttributedText
        title = titleAttributedText
        iata = place.iata
        location = LocationPM(locationModel: place.location)
    }
    
}
