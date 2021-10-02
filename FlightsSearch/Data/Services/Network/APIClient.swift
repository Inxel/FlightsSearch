//
//  APIClient.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

// MARK: - Base

final class APIClient: APIClientProtocol {
    
    // MARK: Properties
    
    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = .default
        let session = URLSession(configuration: configuration)
        return session
    }()
    
}

// MARK: - Public API

extension APIClient {
    
    func send<T: APIRequest>(
        _ apiRequest: T
    ) async -> Result<T.Response, Error> {
        do {
            let url = try makeURL(for: apiRequest.urlString)
            let urlRequest = try makeURLRequest(for: url, requestModel: apiRequest)

            let (data, response) = try await session.data(for: urlRequest)

            /* Checking validity of http response --------------------------------- */
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(APIError.somethingWentWrong)
            }
            /* -------------------------------------------------------------------- */


            /* Checking HTTP status code ------------------------------------------ */
            switch httpResponse.statusCode {
            case 200...299:
                let parsedData = try JSONDecoder().decode(T.Response.self, from: data)
                    return .success(parsedData)

            case 500...599:
                return .failure(APIError.serverIsNonResponsive)

            default:
                return .failure(APIError.somethingWentWrong)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func cancelAllTasks() {
        session.getAllTasks { tasks in tasks.forEach { $0.cancel() } }
    }
    
}

// MARK: - Private API

extension APIClient {
    
    private func makeURL(for urlString: String) throws -> URL {
        guard
            let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedUrlString)
        else { throw APIError.invalidURL }
        
        return url
    }
    
    private func makeURLRequest<T: APIRequest>(for url: URL, requestModel: T) throws -> URLRequest {
        var request = URLRequest(url: url)
        let httpMethod = requestModel.httpMethod
        request.httpMethod = httpMethod.rawValue
        
        switch httpMethod {
        case .get, .delete:
            break
            
        case .post, .put, .patch:
            try addEncodedBody(to: &request, with: requestModel)
        }
        
        return request
    }
    
    private func addEncodedBody<T: APIRequest>(to urlRequest: inout URLRequest, with apiRequest: T) throws {
        try addJSONBody(to: &urlRequest, with: apiRequest)
    }
    
    private func addJSONBody<T: APIRequest>(to urlRequest: inout URLRequest, with apiRequest: T) throws {
        guard let body = try? JSONEncoder().encode(apiRequest) else { throw APIError.invalidData }
        urlRequest.httpBody = body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

}
