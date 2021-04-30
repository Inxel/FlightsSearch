//
//  BaseViewModel.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 30.04.2021.
//

import Foundation

class BaseViewModel<C: Coordinator> {
    
    weak var coordinator: C?
    
    init(coordinator: C) {
        self.coordinator = coordinator
    }
    
}
