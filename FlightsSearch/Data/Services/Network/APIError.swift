//
//  APIError.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 30.04.2021.
//

enum APIError: Error {
    case notConnectedToInternet
    case timeOut
    case serverIsNonResponsive
    case invalidURL
    case invalidData
    case somethingWentWrong
}
