//
//  FlightsSearchViewModel.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

protocol FlightsSearchViewModelProtocol {
    var items: [PlacePM] { get }
    var itemsDidUpdate: TypeHandler<Bool>? { get set }
    var sameAirportDidSelect: Handler? { get set }
    func didSelectItem(at index: Int)
    func getItems(by query: String)
    func clearItems()
}

final class FlightsSearchViewModel: BaseViewModel<FlightsCoordinator> {
    
    // MARK: - Properties
    
    private let provider: FligthsSearchProviding
    
    private(set) var items: [PlacePM] = [] {
        didSet {
            itemsDidUpdate?(items.isEmpty)
        }
    }
    var itemsDidUpdate: TypeHandler<Bool>?
    var sameAirportDidSelect: Handler?
    
    private let debouncer: Debouncer = Debouncer(seconds: 0.3)
    
    private var depaturePlace: PlacePM = PlacePM(
        city: NSAttributedString(string: "Saint Petersburg, Russia"),
        airport: NSAttributedString(string: "Pulkovo Airport"),
        iata: "LED",
        cityIata: "LED",
        location: LocationPM(latitude: 59.806084, longitude: 30.3083)
    )
    
    // MARK: - Init
    
    init(coordinator: FlightsCoordinator, provider: FligthsSearchProviding) {
        self.provider = provider
        super.init(coordinator: coordinator)
    }
    
}

// MARK: - Public API

extension FlightsSearchViewModel {
    
    func getItems(by query: String) {
        debouncer.debounce { [weak self] in
            self?.getAirports(by: query)
        }
    }
    
    func clearItems() {
        debouncer.cancel()
        self.items = []
    }
    
}

// MARK: - Private API

extension FlightsSearchViewModel {
    
    private func getAirports(by query: String) {
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
        let destinationPlace = items[index]
        
        guard destinationPlace != depaturePlace else {
            sameAirportDidSelect?()
            return
        }
        
        coordinator?.goToAirplaneAnimationViewController(departurePlace: depaturePlace, destinationPlace: destinationPlace)
    }
    
}
