//
//  API.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

enum API {}

// MARK: - Flights Searching

extension API {
    
    enum FlightsSearch {
        static func getPlaces(query: String) -> String {
            let localeCode = Locale.current.languageCode ?? "ru"
            return "http://places.aviasales.ru/places?term=\(query)&locale=\(localeCode)"
        }
    }
    
}
