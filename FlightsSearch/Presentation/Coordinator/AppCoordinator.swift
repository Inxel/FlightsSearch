//
//  AppCoordinator.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 30.04.2021.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    let rootViewController: UIViewController
    private let flightsCoordinator: FlightsCoordinator
    
    // MARK: - Init
    
    init() {
        let rootNavigationController = UINavigationController()
        rootViewController = rootNavigationController
        flightsCoordinator = FlightsCoordinator(navigationController: rootNavigationController)
    }
    
}

// MARK: - Public API

extension AppCoordinator {
    
    func start() {
        flightsCoordinator.start()
    }
    
}
