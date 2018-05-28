//
// Created by Ryan Liang on 5/18/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// Header
typealias HTTPHeaders = [String: String]

/// Represents what the provider should do with this endpoint
enum Action {

    /// Does nothing
    case plain

    /// Request with url parameters
    case parameters(parameters: Parameters)
}

/// Represent an API endpoint
protocol Endpoint {

    /// Base URL, e.g. "https://api.twitch.tv"
    var baseURL: URL { get }

    /// Relative component to the URL
    /// Notice this will by appended to the baseURL by URL.appendingPathComponent()
    var path: String { get }

    /// Action
    var action: Action { get }

    /// HTTP Method
    var method: HTTPMethod { get }

    /// Headers
    var headers: HTTPHeaders? { get }

    func urlRequest() throws -> URLRequest
}

extension Endpoint {

    /// Default implementation to returns a URLRequest for provider
    func urlRequest() throws -> URLRequest {

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
