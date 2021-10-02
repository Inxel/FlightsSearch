//
//  FligthsSearchProvider.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

final class FligthsSearchProvider: Networking {
    
    // MARK: - Properties
    
    var apiClient: APIClientProtocol
    
    // MARK: - Init
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
}

// MARK: - FligthsSearchProviderProtocol

extension FligthsSearchProvider: FligthsSearchProviding {

    func getPlaces(query: String) async -> APIResult<[PlaceModel]> {
        let request = FligthsSearchRequest(query: query)
        let result = await self.send(request)

        switch result {
            case let .success(response):
                let places = response.map { PlaceModel(placeDTO: $0, query: query) }
                return .success(places)
            case let .failure(error):
                return .failure(error)
        }
    }
    
}
