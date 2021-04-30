//
//  FlightsCoordinator.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 30.04.2021.
//

import UIKit

final class FlightsCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

// MARK: - Public

extension FlightsCoordinator {
    
    func start() {
        let apiClient = APIClient()
        let provider = FligthsSearchProvider(apiClient: apiClient)
        let viewModel = FlightsSearchViewModel(coordinator: self, provider: provider)
        let controller = FlightsSearchViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: true)
    }
    
    func goToAirplaneAnimationViewController(departurePlace: PlacePM, destinationPlace: PlacePM) {
        let viewModel = AirplaneAnimationViewModel(
            coordinator: self,
            departurePlace: departurePlace,
            destinationPlace: destinationPlace
        )
        let controller = AirplaneAnimationViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
    
}
