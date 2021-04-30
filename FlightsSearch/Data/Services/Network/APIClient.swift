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
    
    func send<T>(
        _ apiRequest: T,
        destinationQueue: OperationQueue = .main,
        completion: @escaping ResultHandler<T.Response>
    ) where T: APIRequest {
        do {
            let url = try makeURL(for: apiRequest.urlString)
            
            try makeURLRequest(for: url, requestModel: apiRequest) { request in
                
                self.session.dataTask(with: request) { [weak self] data, response, error in
                    /* Checking if internet is connected ---------------------------------- */
                    if (error as? URLError)?.code == .notConnectedToInternet {
                        destinationQueue.addOperation {
                            completion(.failure(.notConnectedToInternet))
                        }
                        return
                    }
                    /* -------------------------------------------------------------------- */
                    
                    
                    /* Checking if request has timed-out----------------------------------- */
                    if (error as? URLError)?.code == .timedOut {
                        destinationQueue.addOperation {
                            completion(.failure(.timeOut))
                        }
                        return
                    }
                    /* -------------------------------------------------------------------- */
                    
                    
                    /* Checking validity of http response --------------------------------- */
                    guard let httpResponse = response as? HTTPURLResponse else {
                        destinationQueue.addOperation{
                            completion(.failure(.somethingWentWrong))
                        }
                        return
                    }
                    /* -------------------------------------------------------------------- */
                    
                    
                    /* Checking HTTP status code ------------------------------------------ */
                    switch httpResponse.statusCode {
                    case 200...299:
                            self?.decodeResponse(from: data, completion: completion)
                        
                    case 500...599:
                        destinationQueue.addOperation {
                            completion(.failure(.serverIsNonResponsive))
                        }
                        
                    default:
                        destinationQueue.addOperation {
                            completion(.failure(.somethingWentWrong))
                        }
                    }
                    /* -------------------------------------------------------------------- */
                }.resume()
            }
        } catch {
            destinationQueue.addOperation {
                completion(.failure(.somethingWentWrong))
            }
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
    
    private func makeURLRequest<T: APIRequest>(for url: URL, requestModel: T, completion: @escaping TypeHandler<URLRequest>) throws {
        var request = URLRequest(url: url)
        let httpMethod = requestModel.httpMethod
        request.httpMethod = httpMethod.rawValue
        
        switch httpMethod {
        case .get, .delete:
            break
            
        case .post, .put, .patch:
            try addEncodedBody(to: &request, with: requestModel)
        }
        
        completion(request)
    }
    
    private func addEncodedBody<T: APIRequest>(to urlRequest: inout URLRequest, with apiRequest: T) throws {
        try addJSONBody(to: &urlRequest, with: apiRequest)
    }
    
    private func addJSONBody<T: APIRequest>(to urlRequest: inout URLRequest, with apiRequest: T) throws {
        guard let body = try? JSONEncoder().encode(apiRequest) else { throw APIError.invalidData }
        urlRequest.httpBody = body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    private func decodeResponse<T: Decodable>(
        from data: Data?,
        destinationQueue: OperationQueue = .main,
        completion: @escaping ResultHandler<T>
    ) {
        destinationQueue.addOperation {
            if
                let data = data,
                let result = try? JSONDecoder().decode(T.self, from: data)
            {
                completion(.success(result))
            } else {
                completion(.failure(.invalidData))
            }
        }
    }
    
}
