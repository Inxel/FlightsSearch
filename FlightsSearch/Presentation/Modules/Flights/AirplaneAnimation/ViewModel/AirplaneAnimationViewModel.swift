//
//  AirplaneAnimationViewModel.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 01.05.2021.
//

import Foundation
import MapKit

protocol AirplaneAnimationViewModelProtocol {
    var departurePlace: PlacePM { get }
    var destinationPlace: PlacePM { get }
    var planeShouldUpdate: TypeHandler<(coordinate: CLLocationCoordinate2D, angle: Double)>? { get set }
    var mapCenter: LocationPM { get }
    func updatePlanePosition(flightpathPolyline: MKPolyline, currentPosition: Int)
}

final class AirplaneAnimationViewModel: BaseViewModel<FlightsCoordinator> {
    
    // MARK: - Properties
    
    private(set) var departurePlace: PlacePM
    private(set) var destinationPlace: PlacePM
    var planeShouldUpdate: TypeHandler<(coordinate: CLLocationCoordinate2D, angle: Double)>?
    
    var mapCenter: LocationPM {
        return LocationPM(
            latitude: (departurePlace.location.latitude + destinationPlace.location.latitude) / 2,
            longitude: (departurePlace.location.longitude + destinationPlace.location.longitude) / 2
        )
    }
    
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
    
    private func convertDegreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    private func getDirectionBetween(firstPoint: MKMapPoint, lastPoint: MKMapPoint) -> Double {
        let x: Double = lastPoint.x - firstPoint.x
        let y: Double = lastPoint.y - firstPoint.y
        
        return fmod(convertRadiansToDegrees(radians: atan2(y, x)), 360.0)
    }
    
}

// MARK: - AirplaneAnimationViewModelProtocol

extension AirplaneAnimationViewModel: AirplaneAnimationViewModelProtocol {
    
    func updatePlanePosition(flightpathPolyline: MKPolyline, currentPosition: Int) {
        let step = 5
        let updatedPosition = currentPosition + step
        guard updatedPosition < flightpathPolyline.pointCount else { return }
        
        let polylinePoints = flightpathPolyline.points()
        let previousPoint = polylinePoints[currentPosition]
        let nextPoint = polylinePoints[updatedPosition]
        
        let direction = getDirectionBetween(firstPoint: previousPoint, lastPoint: nextPoint)
        let angle = convertDegreesToRadians(degrees: direction)
        
        planeShouldUpdate?((nextPoint.coordinate, angle))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.updatePlanePosition(flightpathPolyline: flightpathPolyline, currentPosition: updatedPosition)
        }
    }
    
}
