//
//  NetworkService.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/11.
//

import Foundation

protocol NetworkServiceProviding {
    
    func request(requestType: RequestType,
                 completionHandler: @escaping (Result<Data, NetworkError>) -> Void)
}

enum NetworkError: Error {
    
    case invalidURL
    case reqeustFailed(msg: String)
    case invalidResponse(msg: String)
    case invalidData
}

final class NetworkService: NetworkServiceProviding {
   
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(requestType: RequestType, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = requestType.url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        components.queryItems = requestType.parameter.map({ (key, value)  in
            URLQueryItem(name: key, value: value)
        })
        
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = requestType.method.rawValue
        urlRequest.httpBody = requestType.body
        requestType.header.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(.reqeustFailed(msg: error.localizedDescription)))
                return
            }
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completionHandler(.failure(.invalidResponse(msg: String(response.statusCode))))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            completionHandler(.success(data))
        }.resume()
    }
}
