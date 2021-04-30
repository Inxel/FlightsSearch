//
//  FlightsSearchViewModel.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

protocol FlightsSearchViewModelProtocol {
    var items: [PlacePM] { get set }
    var itemsDidUpdate: Handler? { get set }
    func didSelectItem(at index: Int)
    func getAirports(query: String)
}

final class FlightsSearchViewModel: BaseViewModel<FlightsCoordinator> {
    
    // MARK: - Properties
    
    private let provider: FligthsSearchProviding
    
    var items: [PlacePM] = [] {
        didSet {
            itemsDidUpdate?()
        }
    }
    var itemsDidUpdate: Handler?
    
    // MARK: - Init
    
    init(coordinator: FlightsCoordinator, provider: FligthsSearchProviding) {
        self.provider = provider
        super.init(coordinator: coordinator)
    }
    
}

// MARK: - Public

extension FlightsSearchViewModel {
    
    func getAirports(query: String) {
        provider.getPlaces(query: query) { [weak self] result in
            switch result {
            case let .success(places):
                let items = places.map(PlacePM.init)
                self?.items = items
            case let .failure(error):
                print(error)
            }
        }
    }
    
}

// MARK: - FlightsSearchViewModelProtocol

extension FlightsSearchViewModel: FlightsSearchViewModelProtocol {
    
    func didSelectItem(at index: Int) {
        
    }
    
}
