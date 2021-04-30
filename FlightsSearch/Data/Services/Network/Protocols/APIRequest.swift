//
//  APIRequest.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

protocol APIRequest: Encodable {
    associatedtype Response: Decodable
    var urlString: String { get }
    var httpMethod: HTTPMethod { get }
}

extension APIRequest {
    var httpMethod: HTTPMethod { .get }
}
