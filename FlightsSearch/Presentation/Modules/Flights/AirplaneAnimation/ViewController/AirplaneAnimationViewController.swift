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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
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
    
    private func updatePlanePosition() {
        viewModel.updatePlanePosition(flightpathPolylinePoint: flightpathPolyline, currentPosition: 0)
        viewModel.planeShouldUpdate = { [weak self] position in
            guard let self = self else { return }
            self.planeAnnotation.coordinate = position.coordinate
            self.planeAnnotationView?.transform = self.mapView.transform.rotated(by: CGFloat(position.angle))
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
        mapView.isRotateEnabled = false
        
        let departurePlaceCoordinate = CLLocationCoordinate2D(place: viewModel.departurePlace)
        let destinationPlaceCoordinate = CLLocationCoordinate2D(place: viewModel.destinationPlace)
        
        let region = MKCoordinateRegion(coordinates: [departurePlaceCoordinate, destinationPlaceCoordinate])
        mapView.setRegion(region, animated: false)
        
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
        polylineRender.lineWidth = 4
        polylineRender.lineDashPattern = [1, 8]
        polylineRender.strokeColor = .primaryTintColor
        
        return polylineRender
    }
    
}
