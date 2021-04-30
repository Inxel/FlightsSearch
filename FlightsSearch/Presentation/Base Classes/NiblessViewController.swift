//
//  NiblessViewController.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit

class NiblessViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "This controller is nibless")
    public required init?(coder: NSCoder) {
        fatalError("Loading this ViewController from a nib is unsupported. File: \(#file); Line: \(#line)")
    }
    
}
