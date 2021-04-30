//
//  APIClientProtocol.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

protocol `APIClientProtocol` {
    func send<T: APIRequest>(_ request: T, destinationQueue: OperationQueue, completion: @escaping ResultHandler<T.Response>)
    func cancelAllTasks()
}
