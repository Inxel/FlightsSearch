//
//  ReusableView.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIResponder {
    static var reuseID: String { return .init(describing: self) }
}

