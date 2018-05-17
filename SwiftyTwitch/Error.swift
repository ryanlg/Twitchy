//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

public enum ParameterEncodingFailureReason {
    case missingURL
    case propertyListEncodingFailed(error: Error)
}


enum STError: Error {

    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
}
