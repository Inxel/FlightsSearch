//
//  Networking.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

protocol Networking: AnyObject {
    var apiClient: APIClientProtocol { get }
}

// MARK: - Public API

extension Networking {
    
    func send<T: APIRequest>(
        _ apiRequest: T
    ) async -> APIResult<T.Response> {
        return await apiClient.send(apiRequest)
    }
    
}
