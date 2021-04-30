//
//  FligthsSearchRequest.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

struct FligthsSearchRequest: APIRequest {
    typealias Response = [PlaceDTO]
    
    var urlString: String { API.FlightsSearch.getPlaces(query: query) }
    
    var query: String
}
