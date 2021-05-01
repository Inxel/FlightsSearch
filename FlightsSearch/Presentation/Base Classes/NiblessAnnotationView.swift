//
//  NiblessAnnotationView.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 02.05.2021.
//

import MapKit

class NiblessAnnotationView: MKAnnotationView {
    
    // MARK: - Init
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    @available(*, unavailable, message: "This AnnotationView is nibless")
    required init?(coder: NSCoder) {
        fatalError("Loading this AnnotationView from a nib is unsupported. File: \(#file); Line: \(#line)")
    }
    
    // MARK: - Could be overridden
    
    func commonInit() {}
    
}

