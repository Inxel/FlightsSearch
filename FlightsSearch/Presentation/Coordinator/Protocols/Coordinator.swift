//
//  Coordinator.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 30.04.2021.
//

import UIKit

protocol BaseCoordinator: AnyObject {
    func start()
}

protocol Coordinator: BaseCoordinator {
    var navigationController: UINavigationController { get }
}
