//
//  AirplaneAnimationViewController.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit
import MapKit

final class AirplaneAnimationViewController: NiblessViewController {
    
    // MARK: - UI Elements
    
    private var myMapView: MKMapView = MKMapView()
    
    // MARK: - Properties
    
    private var viewModel: AirplaneAnimationViewModelProtocol
    
    // MARK: - Init
    
    init(viewModel: AirplaneAnimationViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
}
