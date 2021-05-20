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
    
    private let mapView: MKMapView = MKMapView()
    private var planeAnnotation: PlaneAnnotation = PlaneAnnotation()
    private var flightpathPolyline: MKGeodesicPolyline = MKGeodesicPolyline()
    private var planeAnnotationView: PlaneAnnotationView?
    
    // MARK: - Properties
    
    private var viewModel: AirplaneAnimationViewModelProtocol
    private var displayLink: CADisplayLink?
    private var currentPlanePosition: Int = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeDisplayLink()
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
    
    @objc
    private func updatePlanePosition() {
        let pointCount = flightpathPolyline.pointCount
        let step = pointCount / 250  // defined empirically
        
        let updatedPosition = currentPlanePosition + step
        guard updatedPosition < pointCount else {
            removeDisplayLink()
            return
        }
        
        let polylinePoints = flightpathPolyline.points()
        let previousPoint = polylinePoints[currentPlanePosition]
        let nextPoint = polylinePoints[updatedPosition]
        
        let direction = viewModel.getDirectionBetween(
            firstPoint: Point(x: previousPoint.x, y: previousPoint.y),
            lastPoint: Point(x: nextPoint.x, y: nextPoint.y)
        )
        let angle = viewModel.convertDegreesToRadians(degrees: direction)
        
        planeAnnotation.coordinate = nextPoint.coordinate
        planeAnnotationView?.transform = self.mapView.transform.rotated(by: CGFloat(angle))
        currentPlanePosition = updatedPosition
    }
    
    private func startPlaneAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(updatePlanePosition))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    private func removeDisplayLink() {
        displayLink?.isPaused = true
        displayLink?.invalidate()
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
        startPlaneAnimation()
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
