//
//  MapView+Dequeueing.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 01.05.2021.
//

import MapKit

extension MKMapView {
    
    final func dequeueAnnotationView<T: MKAnnotationView>(_ annotationView: T.Type) -> MKAnnotationView? where T: ReusableView {
        return dequeueReusableAnnotationView(withIdentifier: annotationView.reuseID)
    }
    
}
