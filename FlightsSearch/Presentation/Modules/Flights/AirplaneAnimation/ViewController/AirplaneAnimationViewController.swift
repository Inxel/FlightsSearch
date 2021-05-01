//
//  AirplaneAnimationViewController.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit
import MapKit
import SnapKit

final class AirplaneAnimationViewController: NiblessViewController {
    
    // MARK: - UI Elements
    
    private var mapView: MKMapView = MKMapView()
    private var planeAnnotation: PlaneAnnotation = PlaneAnnotation()
    private var flightpathPolyline: MKGeodesicPolyline = MKGeodesicPolyline()
    private var planeAnnotationView: PlaneAnnotationView?
    
    // MARK: - Properties
    
    private var viewModel: AirplaneAnimationViewModelProtocol
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Init
    
    init(viewModel: AirplaneAnimationViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
}

// MARK: - Private API

extension AirplaneAnimationViewController {
    
    private func addPlaceAnnotation(place: PlacePM) {
        let annotation = AirportPointAnnotation(place: place)
        mapView.addAnnotation(annotation)
    }
    
    private func updatePlanePosition(currentPosition: Int = 0) {
        let step = 5
        let updatedPosition = currentPosition + step
        guard updatedPosition < flightpathPolyline.pointCount else { return }
        
        let polylinePoints = flightpathPolyline.points()
        let previousMapPoint = polylinePoints[currentPosition]
        let nextMapPoint = polylinePoints[updatedPosition]
        
        let planeDirection = viewModel.getAngleBetween(
            firstPoint: Point(x: previousMapPoint.x, y: previousMapPoint.y),
            lastPoint: Point(x: nextMapPoint.x, y: nextMapPoint.y)
        )
        
        planeAnnotation.coordinate = nextMapPoint.coordinate
        planeAnnotationView?.transform = mapView.transform.rotated(by: CGFloat(viewModel.convertDegreesToRadians(degrees: planeDirection)))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.updatePlanePosition(currentPosition: updatedPosition)
        }
    }
    
}

// MARK: - Configure Layout

extension AirplaneAnimationViewController {
    
    private func configureUI() {
        view.backgroundColor = .primaryBackgroundColor
        view.addSubview(mapView)
        configureMapView()
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        configureOverlay()
        addPlaceAnnotation(place: viewModel.departurePlace)
        addPlaceAnnotation(place: viewModel.destinationPlace)
        configurePlaneAnnotation()
    }
    
    private func configureOverlay() {
        var coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(place: viewModel.departurePlace),
            CLLocationCoordinate2D(place: viewModel.destinationPlace)
        ]
        
        flightpathPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: coordinates.count)
        mapView.addOverlay(flightpathPolyline)
    }
    
    private func configurePlaneAnnotation() {
        planeAnnotation = PlaneAnnotation()
        mapView.addAnnotation(planeAnnotation)
        updatePlanePosition()
    }
    
}

// MARK: - MKMapViewDelegate

extension AirplaneAnimationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case let airportPoint as AirportPointAnnotation:
            if let dequeuedView = mapView.dequeueAnnotationView(AirportAnnotationView.self) {
                dequeuedView.annotation = annotation
                return dequeuedView
            } else {
                let view = AirportAnnotationView(annotation: airportPoint, reuseIdentifier: AirportAnnotationView.reuseID)
                return view
            }
        case let planeAnnotation as PlaneAnnotation:
            if planeAnnotationView == nil {
                planeAnnotationView = PlaneAnnotationView(annotation: planeAnnotation, reuseIdentifier: PlaneAnnotationView.reuseID)
            }
            return planeAnnotationView
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRender = MKPolylineRenderer(overlay: overlay)
        polylineRender.lineWidth = 5
        polylineRender.lineDashPattern = [1, 10]
        polylineRender.strokeColor = .primaryTintColor
        
        return polylineRender
    }
    
}
