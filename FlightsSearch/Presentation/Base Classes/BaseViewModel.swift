//
//  BaseViewModel.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 30.04.2021.
//

import Foundation

class BaseViewModel<C: Coordinator> {
    
    // MARK: - Properties
    
    weak var coordinator: C?
    
    // MARK: - Init
    
    init(coordinator: C) {
        self.coordinator = coordinator
    }
    
}
