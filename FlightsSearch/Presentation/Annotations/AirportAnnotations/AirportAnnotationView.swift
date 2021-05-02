//
//  AirportAnnotationView.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 01.05.2021.
//

import UIKit
import MapKit
import SnapKit

final class AirportAnnotationView: NiblessAnnotationView, ReusableView {
    
    // MARK: - UI Elements
    
    private let backgroundView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        titleLabel.text = ""
    }
    
    // MARK: - Init
    
    init(annotation: AirportPointAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configureUI(annotation: annotation)
    }
    
}

// MARK: - Configure Layout

extension AirportAnnotationView {
    
    private func configureUI(annotation: AirportPointAnnotation?) {
        configureBackgroundView(annotation: annotation)
        
        let size = backgroundView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        backgroundView.frame.size = size
        backgroundView.frame.origin = .init(
            x: backgroundView.frame.minX - backgroundView.frame.width / 2,
            y: backgroundView.frame.minY - backgroundView.frame.height / 2
        )
        backgroundView.layer.cornerRadius = size.height / 2
        
        addSubview(backgroundView)
    }
    
    private func configureBackgroundView(annotation: AirportPointAnnotation?) {
        backgroundView.backgroundColor = .primaryBackgroundColor
        backgroundView.layer.borderColor = UIColor.primaryTintColor.cgColor
        backgroundView.layer.borderWidth = 3
        backgroundView.alpha = 0.8
        backgroundView.addSubview(titleLabel)
        
        configureTitleLabel(withTitle: annotation?.title)
    }
    
    private func configureTitleLabel(withTitle title: String?) {
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = .primaryTintColor
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(5)
            make.bottom.equalTo(backgroundView).offset(-5)
            make.leading.equalTo(backgroundView).offset(10)
            make.trailing.equalTo(backgroundView).offset(-10)
            make.centerX.centerY.equalTo(backgroundView)
        }
    }
    
}
