//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

/// Initialize a URL from an endpoint
extension URL {

    init(endpoint: Endpoint) {

        self = endpoint.baseURL.appendingPathComponent(endpoint.path)
    }
}