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
    
    func send<T>(
        _ apiRequest: T,
        destinationQueue: OperationQueue = .main,
        completion: @escaping ResultHandler<T.Response>
    ) where T: APIRequest {
        apiClient.send(apiRequest, destinationQueue: destinationQueue, completion: completion)
    }
    
}
