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

// MARK: - Layout

extension AirplaneAnimationViewController {
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        configureMapView()
    }
    
    private func configureMapView() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

