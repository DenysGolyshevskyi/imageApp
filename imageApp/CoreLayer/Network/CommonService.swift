//
//  CommonService.swift
//  giphyApp
//
//  Created by Denys on 30.01.2023.
//

import Foundation
import Alamofire

public protocol CommonService: URLRequestConvertible {
    typealias HTTPMethod = Alamofire.HTTPMethod
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var timeoutInterval: TimeInterval { get }
    var host: String { get }
}

public extension CommonService {
    
    var headers: [String : String]? {
        return nil
    }
    
    var timeoutInterval: TimeInterval {
        return 10
    }
    
    var host: String {
        return EnvironmentVars.apiHost
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: host)?.appendingPathComponent(path) else {
            throw NetworkError.badUrl
        }
        var mutableURLRequest = URLRequest(url: url)

        mutableURLRequest.httpMethod = method.rawValue
        mutableURLRequest.timeoutInterval = timeoutInterval
        if let headers = headers {
            for (key, value) in headers {
                mutableURLRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let url = mutableURLRequest.url {
            print("REQUEST: \(method.rawValue) \(url)")
            print("Request headers: \(mutableURLRequest.allHTTPHeaderFields ?? [:])")
            if let parameters = parameters {
               print("Request data: \(parameters)")
            }
        }
        
        if let parameters = parameters {
            return try encodingForRequest().encode(mutableURLRequest, with: parameters)
        } else {
            return mutableURLRequest
        }
    }

    private func encodingForRequest() -> ParameterEncoding {
        switch method {
        case .post, .put, .delete, .patch:
            return Alamofire.JSONEncoding.default as ParameterEncoding
        case .get:
            return Alamofire.URLEncoding.default as ParameterEncoding
        default:
            return Alamofire.URLEncoding.default as ParameterEncoding
        }
    }
}
