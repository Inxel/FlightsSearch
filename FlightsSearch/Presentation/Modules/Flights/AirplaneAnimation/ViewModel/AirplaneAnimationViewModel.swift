//
//  AirplaneAnimationViewModel.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 01.05.2021.
//

import Foundation

protocol AirplaneAnimationViewModelProtocol {
    var departurePlace: PlacePM { get }
    var destinationPlace: PlacePM { get }
}

final class AirplaneAnimationViewModel: BaseViewModel<FlightsCoordinator> {
    
    // MARK: - Properties
    
    private(set) var departurePlace: PlacePM
    private(set) var destinationPlace: PlacePM
    
    // MARK: - Init
    
    init(coordinator: FlightsCoordinator, departurePlace: PlacePM, destinationPlace: PlacePM) {
        self.departurePlace = departurePlace
        self.destinationPlace = destinationPlace
        super.init(coordinator: coordinator)
    }
    
}

// MARK: - AirplaneAnimationViewModelProtocol

extension AirplaneAnimationViewModel: AirplaneAnimationViewModelProtocol {}
