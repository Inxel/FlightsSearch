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
    
    // MARK: - Init
    
    init(annotation: AirportPointAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configureUI(annotation: annotation)
    }
    
}

// MARK: - Configure Layout

extension AirportAnnotationView {
    
    private func configureUI(annotation: AirportPointAnnotation?) {
        let view = createView()
        let label = createLabel(withTitle: annotation?.title)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view).offset(5)
            make.bottom.equalTo(view).offset(-5)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
            make.centerX.centerY.equalTo(view)
        }
        
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        view.frame.size = size
        view.frame.origin = .init(
            x: view.frame.minX - view.frame.width / 2,
            y: view.frame.minY - view.frame.height / 2
        )
        view.layer.cornerRadius = size.height / 2
        
        addSubview(view)
    }
    
    private func createView() -> UIView {
        let view = UIView()
        view.backgroundColor = .primaryBackgroundColor
        view.layer.borderColor = UIColor.primaryTintColor.cgColor
        view.layer.borderWidth = 3
        view.alpha = 0.8
        
        return view
    }
    
    private func createLabel(withTitle title: String?) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .primaryTintColor
        
        return label
        
    }
    
}
