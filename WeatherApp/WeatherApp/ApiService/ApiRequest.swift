//
//  ApiRequest.swift
//  WeatherApp
//
//  Created by Lara Poveda on 04/10/2020.
//

import Foundation

public protocol APIRequest {
    
    var baseURLString: String {get set}

    var relativePath: String { get set }
    var method: HTTPMethod { get set }
    var parameters: [String: Any]? { get set }
    var headers: [String: String]? { get set }
    func asURLRequest() throws -> URLRequest
}

extension APIRequest {
    func asURLRequest() throws -> URLRequest {

        let url: URL = {
            var url = URL(string: self.baseURLString)!
            url.appendPathComponent(relativePath)
            if(method == .get){
                var urlComponents = URLComponents(string: url.absoluteString)
                urlComponents!.queryItems = parameters!.getURLEncodedParameters()
                url = urlComponents!.url!
            }
            return url
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = self.headers ?? [:]
        
        return urlRequest
    }
    
    public var urlRequest: URLRequest? { return try? asURLRequest() }
    
}


public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "get"
    case head    = "HEAD"
    case post    = "post"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}


extension Dictionary {
    
    func getURLEncodedParameters() -> [URLQueryItem]{
        
        let paramsArray = self.map{(key, value) -> URLQueryItem in
            
            return URLQueryItem(name: key as! String, value: value as! String)
        }
        return paramsArray
    }
    
}
