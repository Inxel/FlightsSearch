//
//  Optional+String.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 01.05.2021.
//

import Foundation

extension Optional where Wrapped == String {
    
    var isNotBlank: Bool {
        guard let text = self?.trimmingCharacters(in: .whitespacesAndNewlines) else { return false }
        return !text.isEmpty
    }
    
}
