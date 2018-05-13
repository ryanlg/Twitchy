//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

internal extension URLRequest {

    func encoded(parameters: Parameters, parameterEncoding: ParameterEncoding) throws -> URLRequest {

        return try parameterEncoding.encode(self, with: parameters)
    }
}
