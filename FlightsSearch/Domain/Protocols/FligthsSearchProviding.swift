//
//  FligthsSearchProviding.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 30.04.2021.
//

import Foundation

protocol FligthsSearchProviding {
    func getPlaces(query: String, completion: @escaping ResultHandler<[PlaceModel]>)
}
