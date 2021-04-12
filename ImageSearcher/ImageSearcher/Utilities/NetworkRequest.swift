//
//  NetworkRequest.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/11.
//

import Foundation

enum RequestMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol RequestType {
    
    var url:URL? { get }
    var parameter: [String: String] { get }
    var header: [String: String] { get }
    var method: RequestMethod { get }
    var body: Data? { get }
}
