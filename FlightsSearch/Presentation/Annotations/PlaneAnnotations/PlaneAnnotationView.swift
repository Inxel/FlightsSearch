//
//  PlaneAnnotation.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 02.05.2021.
//

import MapKit

final class PlaneAnnotationView: NiblessAnnotationView, ReusableView {
    
    init(annotation: PlaneAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        image = .plane
    }
    
}
