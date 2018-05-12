//
// Created by Ryan Liang on 5/18/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum Action {
    
    case plain
    
    case parameters(parameters: Parameters)
}

public protocol Endpoint {

    var baseURL: URL { get }

    var path: String { get }

    var action: Action { get }

    var method: HTTPMethod { get }

    var headers: HTTPHeaders? { get }
}

extension Endpoint {

    public func urlRequest() throws -> URLRequest {

        var request = URLRequest(url: URL(endpoint: self))

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        switch action {
        case .plain:
            return request

        case let .parameters(parameters: params):
            let encoder = URLEncoding()
            return try request.encoded(parameters: params, parameterEncoding: encoder)
        }
    }
}

