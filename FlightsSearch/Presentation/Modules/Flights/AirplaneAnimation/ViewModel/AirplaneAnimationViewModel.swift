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
    func convertDegreesToRadians(degrees: Double) -> Double
    func getDirectionBetween(firstPoint: Point<Double>, lastPoint: Point<Double>) -> Double
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

// MARK: - Private API

extension AirplaneAnimationViewModel {
    
    private func convertRadiansToDegrees(radians: Double) -> Double {
        return radians * 180.0 / .pi
    }
    
}

// MARK: - AirplaneAnimationViewModelProtocol

extension AirplaneAnimationViewModel: AirplaneAnimationViewModelProtocol {
    
    func convertDegreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    func getDirectionBetween(firstPoint: Point<Double>, lastPoint: Point<Double>) -> Double {
        let x: Double = lastPoint.x - firstPoint.x
        let y: Double = lastPoint.y - firstPoint.y
        
        return fmod(convertRadiansToDegrees(radians: atan2(y, x)), 360.0)
    }
    
}
