//
//  APIClientProtocol.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

protocol APIClientProtocol {
    func send<T: APIRequest>(_ apiRequest: T) async -> Result<T.Response, Error>
    func cancelAllTasks()
}
