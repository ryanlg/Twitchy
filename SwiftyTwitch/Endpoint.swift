//
// Created by Ryan Liang on 5/18/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]

public enum HTTPMethod: String {
    
    case options = "OPTIONS"
    case get = "GET"
    case post = "POST"
}

public enum Action {
    
    case plain
    
    case parameters(parameters: Parameters)
}

protocol Endpoint {

    var baseURL: URL { get }

    var path: String { get }

    var action: Action { get }

    var method: HTTPMethod { get }

    var headers: HTTPHeaders? { get }
}

