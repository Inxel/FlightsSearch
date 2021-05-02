//
//  Equatable+KeyPath.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 02.05.2021.
//

import Foundation

extension Equatable {
    
    func checkIfEqualTo<T: Equatable>(_ other: Self, byComparing keyPaths: KeyPath<Self, T>...) -> Bool {
        return keyPaths.contains(where: { self[keyPath: $0] == other[keyPath: $0] })
    }
    
}
